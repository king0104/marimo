package com.ssafy.marimo.common.util;

import com.ssafy.marimo.common.properties.EncryptProperties;
import com.ssafy.marimo.exception.ErrorStatus;
import com.ssafy.marimo.exception.ServerException;
import java.nio.ByteBuffer;
import java.util.Base64;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class IdEncryptionUtil {

    private static final String CIPHER_ALGORITHM = "AES/ECB/PKCS5Padding";
    private static final String KEY_ALGORITHM = "AES";

    private final EncryptProperties encryptProperties;

    public String encrypt(Integer value) {
        try {
            SecretKeySpec secretKeySpec = new SecretKeySpec(encryptProperties.getKey().getBytes(), KEY_ALGORITHM);
            Cipher cipher = Cipher.getInstance(CIPHER_ALGORITHM);
            cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec);
            byte[] valueBytes = ByteBuffer.allocate(Integer.BYTES).putInt(value).array();
            byte[] encryptedData = cipher.doFinal(valueBytes);
            return Base64.getUrlEncoder().withoutPadding().encodeToString(encryptedData);
        } catch (Exception e) {
            log.error("Encryption failed", e);
            throw new ServerException(ErrorStatus.INTERNAL_SERVER_ERROR.getErrorCode());
        }
    }

    public Integer decrypt(String encryptedData) {
        try {
            SecretKeySpec secretKeySpec = new SecretKeySpec(encryptProperties.getKey().getBytes(), KEY_ALGORITHM);
            Cipher cipher = Cipher.getInstance(CIPHER_ALGORITHM);
            cipher.init(Cipher.DECRYPT_MODE, secretKeySpec);
            byte[] decodedData = Base64.getUrlDecoder().decode(encryptedData);
            byte[] decryptedBytes = cipher.doFinal(decodedData);
            return ByteBuffer.wrap(decryptedBytes).getInt();
        } catch (Exception e) {
            log.error("Decryption failed", e);
            throw new ServerException(ErrorStatus.INTERNAL_SERVER_ERROR.getErrorCode());
        }
    }
}
