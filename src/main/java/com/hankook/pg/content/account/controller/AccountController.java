package com.hankook.pg.content.account.controller;

import com.hankook.pg.content.account.dto.AccountDto;
import com.hankook.pg.content.account.dto.ResetPwdDto;
import com.hankook.pg.content.account.dto.SearchAccountDto;
import com.hankook.pg.content.account.service.AccountService;
import com.hankook.pg.exception.AuthException;
import com.hankook.pg.share.RegularExpressions;
import com.hankook.pg.share.ResultCode;
import com.hankook.pg.share.Utils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


@RestController
@RequestMapping("/accounts")
public class AccountController {

    @Autowired
    private AccountService accountService;

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public ModelAndView getAccounts(SearchAccountDto search , ModelAndView mav ) {

        System.out.println("=========================================");
//        Map<String, Object> result = accountService.getAccountList(search);
        mav.addObject("test","test");
        mav.setViewName("/account/test");
        return mav;
    }

    @GetMapping(value = "/{id}")
    @ResponseStatus(HttpStatus.OK)
    public AccountDto getAccount(@PathVariable String id) {
        return accountService.getAccount(id);
    }


    @PostMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.CREATED)
    public ResultCode addAccount(@RequestBody  AccountDto dto) {
        return registerAccount(dto, false);
    }



    @PostMapping(value = "/sign-up", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.CREATED)
    public ResultCode signUp(@RequestBody  AccountDto dto) {
        return registerAccount(dto, true);
    }

    @PutMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public ResultCode updateAccount(@PathVariable String id, @RequestBody  AccountDto dto) {

        // 요청한 리소스 아이디와 파라미터 내의 아이디 값 동일여부 확인
        if (!StringUtils.equals(id, dto.getId())) {
            return ResultCode.builder()
                    .code(400)
                    .message("잘못된 요청입니다.")
                    .build();
        }

        if (StringUtils.isNotBlank(dto.getPwd())) {
            // 패스워드 유효성 검사
            ResultCode validationResult = validatePassword(dto.getId(), dto.getPhoneNum(), dto.getPwd());
            if (validationResult.getCode() != 200)
                return validationResult;
        }

        boolean result = accountService.updateAccount(id, dto);
        return ResultCode.builder()
                .code(result ? 200 : 400)
                .message(result ? "OK" : "NOT OK")
                .build();
    }

    @PutMapping(value = "/myInfo", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public ResultCode updateMyAccount(@RequestBody  AccountDto dto, HttpServletRequest request) throws AuthException {

        boolean result = accountService.updateMyAccount("tes", dto);
        return ResultCode.builder()
                .code(result ? 200 : 400)
                .message(result ? "OK" : "NOT OK")
                .build();
    }

    @PostMapping(value = "/{id}/reset-pwd", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public ResultCode resetPassword(@PathVariable String id, @RequestBody  ResetPwdDto dto) {
        return accountService.resetPassword(id, dto);
    }


    @GetMapping(value = "/find-id", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public ResultCode findId(@RequestParam(value = "name") String name,
                             @RequestParam(value = "phoneNum") String phoneNum,
                             @RequestParam(value = "email") String email) {
        String foundId = accountService.findId(name, phoneNum, email);
        if (StringUtils.isNotBlank(foundId))
            return ResultCode.builder().code(200).message(foundId).build();
        else
            return ResultCode.builder().code(400).message("요청하신 정보와 일치하는 내용이 없습니다.").build();
    }

    @GetMapping(value = "/{id}/check-duplicated", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public ResultCode checkDuplicated(@PathVariable String id) {

        // 사용불가 사용자 아이디 체크
        if (Utils.isIllegalUserId(id))
            return ResultCode.builder()
                    .code(400)
                    .message("사용할 수 없는 아이디입니다.")
                    .build();

        boolean isDuplicated = accountService.isDuplicatedId(id);
        return ResultCode.builder().code(isDuplicated ? 400 : 200).message(isDuplicated ? "이미 사용중인 아이디입니다.": "사용 가능한 아이디입니다.").build();
    }

    @GetMapping(value = "/notifications/{id}")
    @ResponseStatus(HttpStatus.OK)
    public ResponseEntity<List<String>> getNotificationList(@PathVariable String id) {
        List<String> result = accountService.findAccountNotifications(id);
        return (result != null) ? new ResponseEntity<>(result, HttpStatus.OK) : new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    /**
     * 계정 등록
     * - 회원 가입 요청 및 계정 등록 처리
     *
     * @param dto
     * @return
     */
    private ResultCode registerAccount(AccountDto dto, boolean isSignUp) {
        // 사용불가 사용자 아이디 체크
        if (Utils.isIllegalUserId(dto.getId()))
            return ResultCode.builder()
                    .code(400)
                    .message("사용할 수 없는 아이디입니다.")
                    .build();

        // 패스워드 유효성 검사
        ResultCode validationResult = validatePassword(dto.getId(), dto.getPhoneNum(), dto.getPwd());
        if (validationResult.getCode() != 200)
            return validationResult;

        boolean result = accountService.addAccount(dto, isSignUp);
        return ResultCode.builder()
                .code(result ? 200 : 400)
                .message(result ? "OK" : "NOT OK")
                .build();
    }

    /**
     * 비밀번호 유효성 검사
     *
     * @param userId         사용자 아이디 포함여부 확인을 위한 사용자 아이디
     * @param phoneNumber    휴대전화번호 포함여부 확인을 위한 휴대전화번호
     * @param password       검사할 비밀번호
     * @return
     */
    private ResultCode validatePassword(String userId, String phoneNumber, String password) {

        // 1. 아이디 포함 여부 체크
        if (password.contains(userId)) {
            return ResultCode.builder()
                    .code(400)
                    .message("아이디가 포함된 비밀번호는 사용할 수 없습니다.")
                    .build();
        }

        // 2. 연락처 포함 여부 체크
        String[] number = {phoneNumber.replace("-", "").substring(3)}; // 010을 제외한 연락처
        if (password.contains(number[0]) || Utils.containContinuousCharacters(password, number, 4)) {
            return ResultCode.builder()
                    .code(400)
                    .message("휴대전화번호가 포함된 비밀번호는 사용할 수 없습니다.")
                    .build();
        }

        String regexpPwd = "((?=.*\\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*].{8,16})";
        Pattern pattern = Pattern.compile(regexpPwd);
        Matcher m = pattern.matcher(password);
        //Preconditions.checkArgument(m.find(), "비밀번호는 영문(대,소문자), 숫자, 특수문자(!@#$%^&*)를 반드시 하나이상 포함한 8~16자리로 입력해야합니다");
        if (m.find()){
            return ResultCode.builder()
                    .code(400)
                    .message("비밀번호는 영문,숫자,특수문자를 조합한 8~16자리 문자열만 사용할 수 있습니다.111")
                    .build();
        }

        // 3. 길이 및 복잡성 체크
        if (!Pattern.matches(RegularExpressions.PASSWORD, password)) {
            return ResultCode.builder()
                    .code(400)
                    .message("비밀번호는 영문,숫자,특수문자를 조합한 8~16자리 문자열만 사용할 수 있습니다.222")
                    .build();
        }

        // 4. 연속성 체크
        String[] targetStrings = {"0123456789", "abcdefghijklmnopqrstuvwxyz", "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "qwertyuiopasdfghjklzxcvbnm", "QWERTYUIOPASDFGHJKLZXCVBNM"};
        if (Utils.containContinuousCharacters(password, targetStrings, 4)) {
            return ResultCode.builder()
                    .code(400)
                    .message("비밀번호에 연속적인 문자/숫자(예: 1111, 1234, abcd)는 사용할 수 없습니다.")
                    .build();
        }

        return ResultCode.builder().code(200).build();
    }

}
