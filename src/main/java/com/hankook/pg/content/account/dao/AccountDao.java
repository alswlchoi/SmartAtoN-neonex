package com.hankook.pg.content.account.dao;

import com.hankook.pg.content.account.dto.AccountDto;
import com.hankook.pg.content.account.dto.SearchAccountDto;
import com.hankook.pg.share.entity.AccountEntity;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface AccountDao {

    /**
     * 계정 목록 조회
     *
     * @param search    검색 조건
     * @return
     */
    List<AccountDto> findAccountList(SearchAccountDto search);

    int findAccountsCount(SearchAccountDto search);

    /**
     * 계정정보 조회
     *
     * @param id        계정 아이디
     * @return
     */
    AccountEntity findAccountById(String id);

    /**
     * 계정 등록
     *
     * @param entity    계정 엔티티
     * @return
     */
    int insertAccount(AccountEntity entity);

    /**
     * 계정 삭제
     *
     * @param id    계정 ID
     * @return
     */
    int deleteAccount(String id);

    /**
     * 계정정보 수정
     *
     * @param entity    계정 엔티티
     * @return
     */
    int updateAccount(AccountEntity entity);

    /**
     * 내계정정보 수정
     *
     * @param entity    계정 엔티티
     * @return
     */
    int updateMyAccount(AccountEntity entity);

    /**
     * 비밀번호 변경
     *
     * @param id        변경할 계정 아이디
     * @param password  변경된 비밀번호
     * @param pwdChgYn  비밀번호 변경 여부 (임시 비밀번호 변경의 경우 N 으로 설정해야 함)
     * @return
     */
    int updatePassword(@Param("id") String id, @Param("password") String password, @Param("pwdChgYn") String pwdChgYn);

    /**
     * 계정 아이디 검색
     *
     * @param name      이름
     * @param phoneNum  휴대전화번호
     * @param email     이메일
     * @return
     */
    String findAccountId(@Param("name") String name, @Param("phoneNum") String phoneNum, @Param("email") String email);

    List<AccountEntity> findManagerAccounts();

    AccountEntity findRootAccount();

    List<String> findAccountNotificationsById(String id);

    int deleteAccountNotificationsById(String id);

    int insertAccountNotification(@Param("id") String id, @Param("svcSe") String svcSe);
}
