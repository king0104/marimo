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
public class EmailAuthService {

    private final JavaMailSender javaMailSender;
    private final String senderEmail = "encjf2070@gmail.com";

    private final Map<String, String> authCodeStore = new ConcurrentHashMap<>();

    public String createNumber() {
        Random random = new Random();
        StringBuilder key = new StringBuilder();

        for (int i = 0; i < 8; i++) {
            int index = random.nextInt(3);
            switch (index) {
                case 0 -> key.append((char) (random.nextInt(26) + 97));
                case 1 -> key.append((char) (random.nextInt(26) + 65));
                case 2 -> key.append(random.nextInt(10));
            }
        }
        return key.toString();
    }

    public MimeMessage createMail(String mail, String number) throws MessagingException {
        MimeMessage message = javaMailSender.createMimeMessage();

        message.setFrom(senderEmail);
        message.setRecipients(MimeMessage.RecipientType.TO, mail);
        message.setSubject("[마리모] 이메일 인증번호 전송, MY LITTLE MOBILITY");

        String body = "<h3>요청하신 인증 번호입니다.</h3>"
                + "<h1>" + number + "</h1>"
                + "<h3>이 코드는 30분 동안 유효합니다. 감사합니다.</h3>";
        message.setText(body, "UTF-8", "html");

        return message;
    }

    public String sendSimpleMessage(String sendEmail) throws MessagingException {
        String number = createNumber();
        authCodeStore.put(sendEmail, number);
        MimeMessage message = createMail(sendEmail, number);
        try {
            javaMailSender.send(message);
        } catch (MailException e) {
            throw new IllegalArgumentException("메일 발송 중 오류가 발생했습니다.");
        }
        return number;
    }

    public boolean verifyAuthCode(String email, String inputCode) {
        String savedCode = authCodeStore.get(email);
        if (savedCode != null && savedCode.equals(inputCode)) {
            authCodeStore.remove(email);
            return true;
        }
        return false;
    }
}
