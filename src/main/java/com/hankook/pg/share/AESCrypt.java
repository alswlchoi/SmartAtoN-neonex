package com.hankook.pg.share;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import com.hankook.pg.common.util.Validity;

import java.nio.charset.StandardCharsets;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

public class AESCrypt {

    /** Key Seed */
    private static final String KEY_SEED = "NEONEXT1029384756HANKOOKTIRE1029";

    /** IV(Initialization Vector) Seed */
    private static final String IV_SEED = KEY_SEED.substring(0,16);

    /** Cipher algorithm */
    private static final String ALGORITHM = "AES";

    /** Transformation (cryptographic algorithm/feedback mode/padding scheme) */
    private static final String AES_CBC_PKCS5PADDING = "AES/CBC/PKCS5Padding";


    /**
     * 문자열 암호화
     * @param str : 암호화 할 문자열
     * @return : AES256 암호화 된 문자열
     */
    public static String encrypt(String str) throws NoSuchPaddingException, NoSuchAlgorithmException, BadPaddingException, IllegalBlockSizeException, InvalidAlgorithmParameterException, InvalidKeyException {
    	String returnStr = "";
    	
    	if(!Validity.isNull(str)) {
	        Cipher cipher = Cipher.getInstance(AES_CBC_PKCS5PADDING);
	        SecretKeySpec secretKeySpec = new SecretKeySpec(IV_SEED.getBytes(), ALGORITHM);
	        IvParameterSpec ivParameterSpec = new IvParameterSpec(IV_SEED.getBytes());
	
	        cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, ivParameterSpec);
	        
	        returnStr = Base64.getEncoder().encodeToString(cipher.doFinal(str.getBytes(StandardCharsets.UTF_8)));
    	}else {
    		returnStr = str;
    	}
        return returnStr;
    }


    /**
     * 문자열 복호화
     * @param encryptedString : AES256 암호화된 문자열
     * @return : 복호화 된 문자열
     */
    public static String decrypt(String encryptedString) throws NoSuchPaddingException, NoSuchAlgorithmException, InvalidAlgorithmParameterException, InvalidKeyException, BadPaddingException, IllegalBlockSizeException {
    	String returnStr = "";
    	
    	if(!Validity.isNull(encryptedString)) {
	        Cipher cipher = Cipher.getInstance(AES_CBC_PKCS5PADDING);
	        SecretKeySpec secretKeySpec = new SecretKeySpec(IV_SEED.getBytes(), ALGORITHM);
	        IvParameterSpec ivParameterSpec = new IvParameterSpec(IV_SEED.getBytes());
	
	        cipher.init(Cipher.DECRYPT_MODE, secretKeySpec, ivParameterSpec);
	        
	        returnStr = new String(cipher.doFinal(Base64.getDecoder().decode(encryptedString)),StandardCharsets.UTF_8); 
    	}else {
    		returnStr = encryptedString;
    	}
        return returnStr;
    }

}
