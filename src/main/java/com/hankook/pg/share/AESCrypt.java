package com.hankook.pg.share;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

/**
 * AESCrypt
 *
 * @author Kyeongjin.Kim
 * @since 2019-07-18
 */
public class AESCrypt {

    /** Key Seed */
    private static final String KEY_SEED = "HANARO_TELECOM00";

    /** IV(Initialization Vector) Seed */
    private static final String IV_SEED = "1234567890123456";

    /** Cipher algorithm */
    private static final String ALGORITHM = "AES";

    /** Transformation (cryptographic algorithm/feedback mode/padding scheme) */
    private static final String AES_CBC_PKCS5PADDING = "AES/CBC/PKCS5Padding";

    /**
     * 암호화된 문자열을 복호화
     *
     * @param encryptedString 암호화된 HEX 문자열
     * @return
     */
    public static String decrypt(String encryptedString) {
        byte[] bytes = hexToByteArr(encryptedString);
        byte[] decryptedBytes = decrypt(bytes);
        return decryptedBytes != null ? new String(decryptedBytes, StandardCharsets.UTF_8) : "";
    }

    /**
     * 암호화된 Byte Array를 복호화
     *
     * @param input 암호화된 Byte Array
     * @return
     */
    private static byte[] decrypt(byte[] input) {
        try {
            byte[] key = KEY_SEED.getBytes();
            SecretKeySpec secretKeySpec = new SecretKeySpec(key, ALGORITHM);
            IvParameterSpec ivParameterSpec = new IvParameterSpec(IV_SEED.getBytes());

            Cipher cipher = Cipher.getInstance(AES_CBC_PKCS5PADDING);
            cipher.init(Cipher.DECRYPT_MODE, secretKeySpec, ivParameterSpec);

            return cipher.doFinal(input);
        } catch (NoSuchAlgorithmException | InvalidKeyException | InvalidAlgorithmParameterException | NoSuchPaddingException | BadPaddingException | IllegalBlockSizeException e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * HEX 값을 byte 배열로 변환
     *
     * @param hex   HEX 문자열
     * @return
     * @throws NumberFormatException
     */
    private static byte[] hexToByteArr(String hex) throws NumberFormatException {
        if(hex.length() % 2 > 0) {
            throw new NumberFormatException("Odd number of digits: " + hex);
        }

        byte[] b = new byte[hex.length() / 2];

        for(int i=0; i<b.length; i++) {
            int i1 = digit(hex.charAt(i*2));
            int i2 = digit(hex.charAt(i*2 + 1));

            if(i1 < 0 || i2 < 0) {
                throw new NumberFormatException("Invalid digit");
            }
            b[i] = (byte)(i1 * 16 + i2);
        } //end of for

        return b;
    }

    private static int digit(int ch) {
        if(ch >= '0' && ch <= '9') {
            return ch - '0';
        }

        if(ch >= 'A' && ch <= 'F') {
            return ch - 'A' + 10;
        }

        if(ch >= 'a' && ch <= 'f') {
            return ch - 'a' + 10;
        }

        throw new NumberFormatException("Digit!");
    }

}
