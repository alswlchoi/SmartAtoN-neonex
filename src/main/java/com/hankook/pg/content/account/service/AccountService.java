package com.hankook.pg.content.account.service;

import com.hankook.pg.content.account.dao.AccountDao;
import com.hankook.pg.content.account.dto.AccountDto;
import com.hankook.pg.content.account.dto.ResetPwdDto;
import com.hankook.pg.content.account.dto.SearchAccountDto;
import com.hankook.pg.share.entity.AccountEntity;
import com.hankook.pg.exception.DataNotFoundException;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.ResultCode;
import com.hankook.pg.share.Results;
import com.hankook.pg.share.Utils;
import com.hankook.pg.share.constant.AccountRole;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;


@Slf4j
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class AccountService {

    @Autowired
    private AccountDao accountDao;


    /**
     * 계정 목록 조회
     *
     * @param search    검색 조건
     * @return
     */
    public Map<String, Object> getAccountList(SearchAccountDto search) {
        List<AccountDto> accounts = accountDao.findAccountList(search);

        Paging paging = new Paging(search, accountDao.findAccountsCount(search));

        return Results.grid(paging, accounts);
    }

    /**
     * 계정 정보 조회
     *
     * @param id    계정 아이디
     * @return
     */
    public AccountDto getAccount(String id) {
        AccountEntity entity = accountDao.findAccountById(id);

        if (entity == null)
            throw new DataNotFoundException("해당 계정을 찾을 수 없습니다.");

        return new AccountDto(entity);
    }

    /**
     * 계정 정보 조회
     *
     * @param id    계정 아이디
     * @return
     */
    public  ResultCode deleteAccount(String id , String role) {


        if(role.equals("ROLE_ADMIN")){
            int cnt = accountDao.deleteAccount(id);
        return ResultCode.builder()
                .code(cnt > 0 ? 200 : 400)
                .message(cnt > 0 ? "계정이 삭제되었습니다": "계정 삭제 오류가 발생하였습니다")
                .build();
        }else{
        return ResultCode.builder()
                .code(400)
                .message("삭제권한이 없습니다")
                .build();
        }
    }

    /**
     * 신규 계정 등록
     *
     * @param dto   신규 계정 정보
     * @return
     */
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public boolean addAccount(AccountDto dto, boolean isSignUp) {
        int cnt = accountDao.insertAccount(dto.convertToEntity());
        if (cnt > 0 && !"Y".equals(dto.getAgreYn())) {
            // 사업PM 권한 이상의 계정목록 조회
            List<AccountEntity> managers = accountDao.findManagerAccounts();
            // 최고관리자 정보 추출
//            AccountEntity admin = managers.stream()
//                                        .filter(account -> AccountRole.ROLE_ADMIN.getRole().equals(account.getRole()))
//                                        .findAny().orElse(AccountEntity.builder().id("admin").name("정산 시스템").build());
            // 알림 메일 발송
//            managers.forEach(manager -> {
//                emailService.sendEmail(NotificationCase.REQ_ACCOUNT, EmailDto.builder()
//                        .rcver(manager.getName())
//                        .rcverEmail(manager.getEmail())
//                        .senderId(admin.getId())
//                        .senderName(admin.getName())
//                        .svcCode("SYS")
//                        .build());
//            });
        }
        return cnt > 0;
    }

    /**
     * 계정 정보 갱신
     *
     * @param id    계정 아이디
     * @param dto   계정 정보
     * @return
     */
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public boolean updateAccount(String id, AccountDto dto) {

        int cnt = 0;
        AccountEntity origin = accountDao.findAccountById(id);

        if (origin == null)
            throw new DataNotFoundException("해당 계정을 찾을 수 없습니다.");

        // 비밀번호가 변경되었으면 비밀번호 업데이트
        if (StringUtils.isNotBlank(dto.getPwd()) &&
                !StringUtils.equals(Utils.convertSha512String(dto.getPwd()), origin.getPwd())) {
            cnt = accountDao.updatePassword(id, Utils.convertSha512String(dto.getPwd()), "Y");
            if (cnt <= 0)
                return false;
        }

        if (dto.getUpdateSelf()) {
            // 개인정보 수정의 경우 알림 목록 업데이트
            List<String> notiRoles = new ArrayList<>(Arrays.asList(AccountRole.ROLE_ADMIN.getRole(),
                                                                   AccountRole.ROLE_OP.getRole(),
                                                                   AccountRole.ROLE_PM.getRole(),
                                                                   AccountRole.ROLE_CP.getRole()));
            if (notiRoles.contains(dto.getRole())) {
                accountDao.deleteAccountNotificationsById(dto.getId());
                if (dto.getNotifications() != null && dto.getNotifications().size() > 0)
                    dto.getNotifications().forEach(svcSe -> accountDao.insertAccountNotification(dto.getId(), svcSe));
            }
        }

        // 계정정보 업데이트
        cnt = accountDao.updateAccount(dto.convertToEntity());

        return cnt > 0;
    }

    /**
     * 내계정 정보 갱신
     *
     * @param id    계정 아이디
     * @param dto   계정 정보
     * @return
     */
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public boolean updateMyAccount(String id, AccountDto dto) {

        int cnt = 0;
        AccountEntity origin = accountDao.findAccountById(id);

        if (origin == null)
            throw new DataNotFoundException("해당 계정을 찾을 수 없습니다.");

        // 비밀번호가 변경되었으면 비밀번호 업데이트
        if (StringUtils.isNotBlank(dto.getPwd()) &&
                !StringUtils.equals(Utils.convertSha512String(dto.getPwd()), origin.getPwd())) {
            cnt = accountDao.updatePassword(id, Utils.convertSha512String(dto.getPwd()), "Y");
            if (cnt <= 0)
                return false;
        }

        if (dto.getUpdateSelf()) {
            // 개인정보 수정의 경우 알림 목록 업데이트
            List<String> notiRoles = new ArrayList<>(Arrays.asList(AccountRole.ROLE_ADMIN.getRole(),
                    AccountRole.ROLE_OP.getRole(),
                    AccountRole.ROLE_PM.getRole(),
                    AccountRole.ROLE_CP.getRole()));
            if (notiRoles.contains(dto.getRole())) {
                accountDao.deleteAccountNotificationsById(dto.getId());
                if (dto.getNotifications() != null && dto.getNotifications().size() > 0)
                    dto.getNotifications().forEach(svcSe -> accountDao.insertAccountNotification(dto.getId(), svcSe));
            }
        }

        // 계정정보 업데이트
        cnt = accountDao.updateMyAccount(dto.convertToEntity());

        return cnt > 0;
    }

    /**
     * 비밀번호 초기화
     *
     * @param id    계정 아이디
     * @param dto   비밀번호 초기화 정보
     * @return
     */
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public ResultCode resetPassword(String id, ResetPwdDto dto) {

        AccountEntity entity = accountDao.findAccountById(id);
        if (entity == null) {
            return ResultCode.builder()
                    .code(400)
                    .message("등록된 회원정보와 일치하지 않습니다.")
                    .build();
        }

        if (StringUtils.equals(id, entity.getId()) &&
            StringUtils.equals(dto.getPhoneNum(), entity.getPhoneNum()) &&
            StringUtils.equals(dto.getEmail(), entity.getEmail())) {

            String tempPwd = Utils.generateTemporayPassword(16);
            int cnt = accountDao.updatePassword(id, Utils.convertSha512String(tempPwd), "N");

            Map<String, String> map = new HashMap<>();
            map.put("계정", entity.getId());
            map.put("임시 비밀번호", tempPwd);

            // 이메일로 임시 비밀번호 발급
            log.info("temporary password => {}", tempPwd);
            AccountEntity admin = accountDao.findRootAccount();
//            emailService.sendEmail(NotificationCase.TEMP_PASSWORD, EmailDto.builder()
//                    .rcver(entity.getName())
//                    .rcverEmail(entity.getEmail())
//                    .senderId(admin.getId())
//                    .senderName(admin.getName())
//                    .svcCode("SYS")
//                    .tableMap(map)
//                    .build());

            return ResultCode.builder()
                    .code(cnt > 0 ? 200 : 400)
                    .message(cnt > 0 ? "회원가입 시 등록된 이메일로 임시비밀번호를 발송하였습니다. 임시비밀번호로 로그인 후 새로운 비밀번호로 변경해주세요.": "등록된 회원정보와 일치하지 않습니다.")
                    .build();
        } else {
            return ResultCode.builder()
                    .code(400)
                    .message("등록된 회원정보와 일치하지 않습니다.")
                    .build();
        }
    }

    /**
     * 계정 아이디 검색
     *
     * @param name      이름
     * @param phoneNum  휴대전화번호
     * @param email     이메일
     * @return
     */
    public String findId(String name, String phoneNum, String email) {
        return accountDao.findAccountId(name, phoneNum, email);
    }

    public boolean isDuplicatedId(String id) {
        AccountEntity entity = accountDao.findAccountById(id);
        return (entity != null);
    }

    public List<String> findAccountNotifications(String id) {
        return accountDao.findAccountNotificationsById(id);
    }
}
