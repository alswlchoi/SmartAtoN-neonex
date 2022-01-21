package com.hankook.pg.mail.service;
import com.hankook.pg.mail.entity.Email;
        import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import javax.mail.internet.MimeMessage;
import java.beans.ConstructorProperties;
import java.util.*;



@Slf4j
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class EmailService {



    @Value("${hkt-mail.system.account}")
    private String SYSTEM_MAIL_ACC;

    @Value("${hkt-mail.system.pass}")
    private String SYSTEM_MAIL_PASS;

    @Value("${hkt-mail.host}")
    private String MAIL_HOST;

    @Value("${hkt-mail.port}")
    private int MAIL_PORT;


    private static JavaMailSender mailSenders;
    private static TemplateEngine templateEngine;
    @ConstructorProperties({"mailSenders", "templateEngine"})
    public  EmailService(JavaMailSender mailSenders, TemplateEngine templateEngine) {
        this.mailSenders = mailSenders;
        this.templateEngine = templateEngine;
    }


    /**
     * 메일센더 한국타이어  SMTP
     *
     * @param type   type
     * @return
     */
    @Async
    public void SenderMail(Email email, String type) {

        String subject;
        String templateName;
        Map<String, Object> tableMap = email.getTableMap();

        if (type.equals("E01")) { // 회원가입승인
            subject = "회원가입 승인 안내 메일";
            templateName = "memberApprove";
        } else if (type.equals("E02")) { // 회원가입 취소
            subject = "회원가입 취소 안내 메일";
            templateName = "memberApproveCancel";
        } else if (type.equals("E03")) { // 트랙예약신청승인
            templateName = "trackReservApprove";
            subject = email.getTitle();
        } else if (type.equals("E04")) { // 트랙예약신청 취소/반려
            templateName = "trackReservApproveCancel";
            subject = email.getTitle();
        } else if (type.equals("E05")) { // 관리자 등록 완료
            subject = "관리자 등록 완료 안내 메일";
            templateName = "adminRegist";
        } else if (type.equals("E06")) { // 임시비밀번호 발송
            subject = "임시 비밀번호 발송";
            templateName = "tempPass";
        } else if (type.equals("E07")) { // 부대시설 예약 신청/승인
            templateName = "shopReservApprove";
            subject = "임시 비밀번호 발송";
        } else if (type.equals("E08")) { // 부대시설 예약 취소/반려
            subject = "임시 비밀번호 발송";
            templateName = "shopReservApproveCancel";
        } else { // 어느것도아님
            subject = "ERROR 안내";
            templateName = "error";
        }

        JavaMailSenderImpl sender = new JavaMailSenderImpl();
        sender.setHost(MAIL_HOST);
        sender.setProtocol("smtp");
        sender.setPort(MAIL_PORT);

        MimeMessage message = sender.createMimeMessage();

        try {
            System.out.println("email=========================================="+email);
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            helper.setTo(email.getRcverEmail());
            helper.setSubject(subject);
            helper.setText(build(subject, tableMap , templateName), true);
            helper.setFrom(SYSTEM_MAIL_ACC);
            sender.setUsername(SYSTEM_MAIL_ACC);
            sender.setPassword(SYSTEM_MAIL_PASS);
            sender.send(message);
            log.info("send OK");


            // 보낸 로그기록  id / 발송시간 /타입을 / 성공,실패
//            emailDao.insert(id, today , templateName , "Y");
        } catch (Exception e) {
            log.error("send mail exception ", e);

            // 실패 로그 기록
//            emailDao.updateFail(id, today , templateName , "Y");
        }
    }


    // 템플릿으로 html 데이터로 변환
        private String build (String subject,  Map < String, Object > tableMap ,String templateName){
            Context context = new Context();
            context.setVariable("subject", subject);
            context.setVariable("tableMap", tableMap);
            return templateEngine.process("thymeleaf/"+templateName, context);
        }
    }
