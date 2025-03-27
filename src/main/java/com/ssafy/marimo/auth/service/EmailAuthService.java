package com.ssafy.marimo.auth.service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

@Service
@RequiredArgsConstructor
@Slf4j
public class EmailAuthService {

    private final JavaMailSender javaMailSender;
    private final String senderEmail = "encjf2070@gmail.com";

    // 인증번호 저장 (실제 운영에서는 Redis나 DB에 저장할 것을 권장)
    private final Map<String, String> authCodeStore = new ConcurrentHashMap<>();

    /**
     * 8자리 랜덤 인증 코드를 생성합니다.
     */
    public String createNumber() {
        Random random = new Random();
        StringBuilder key = new StringBuilder();

        for (int i = 0; i < 8; i++) { // 인증 코드 8자리
            int index = random.nextInt(3); // 0 ~ 2
            switch (index) {
                case 0 -> key.append((char) (random.nextInt(26) + 97)); // 소문자
                case 1 -> key.append((char) (random.nextInt(26) + 65)); // 대문자
                case 2 -> key.append(random.nextInt(10));              // 숫자
            }
        }
        return key.toString();
    }

    /**
     * 인증번호를 포함한 HTML 메일 메시지를 생성합니다.
     */
    public MimeMessage createMail(String mail, String number) throws MessagingException {
        MimeMessage message = javaMailSender.createMimeMessage();

        message.setFrom(senderEmail);
        message.setRecipients(MimeMessage.RecipientType.TO, mail);
        message.setSubject("My Little Mobility 'marimo' 이메일 인증");

        String body = "<h3>요청하신 인증 번호입니다.</h3>"
                + "<h1>" + number + "</h1>"
                + "<h3>이 코드는 10분 동안 유효합니다. 감사합니다.</h3>";
        message.setText(body, "UTF-8", "html");

        return message;
    }

    /**
     * 인증번호를 생성하여 메일을 발송하고, 생성된 인증번호를 저장 후 반환합니다.
     */
    public String sendSimpleMessage(String sendEmail) throws MessagingException {
        String number = createNumber(); // 랜덤 인증번호 생성
        // 인증번호를 메모리에 저장 (키: 이메일, 값: 인증번호)
        authCodeStore.put(sendEmail, number);
        MimeMessage message = createMail(sendEmail, number);
        try {
            javaMailSender.send(message);
            log.info("인증 메일 전송 성공: {}", sendEmail);
        } catch (MailException e) {
            log.error("메일 발송 중 오류 발생", e);
            throw new IllegalArgumentException("메일 발송 중 오류가 발생했습니다.");
        }
        return number;
    }

    /**
     * 요청된 이메일과 인증번호가 일치하는지 검증합니다.
     */
    public boolean verifyAuthCode(String email, String inputCode) {
        String savedCode = authCodeStore.get(email);
        if (savedCode != null && savedCode.equals(inputCode)) {
            // 검증 성공 후 사용한 인증번호는 제거합니다.
            authCodeStore.remove(email);
            return true;
        }
        return false;
    }
}
