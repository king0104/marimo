package com.ssafy.marimo.common.util;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import com.ssafy.marimo.common.config.TestEncryptPropertiesConfig;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest(classes = {IdEncryptionUtil.class, TestEncryptPropertiesConfig.class})
class IdEncryptionUtilTest {

    @Autowired
    private IdEncryptionUtil idEncryptionUtil;

    @Test
    @DisplayName("정수 ID를 암호화하고 다시 복호화하면 원래 값과 일치해야 한다")
    void encryptAndDecryptTest() {
        // given
        Integer originalId = 6;

        // when
        String encrypted = idEncryptionUtil.encrypt(originalId);
        Integer decrypted = idEncryptionUtil.decrypt(encrypted);

        // then
        assertNotNull(encrypted, "암호화된 값은 null이 아니어야 함");
        assertEquals(originalId, decrypted, "복호화한 값은 원래 값과 같아야 함");

        System.out.println("Encrypted: " + encrypted);
        System.out.println("Decrypted: " + decrypted);
    }
}
