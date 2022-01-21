package com.hankook.pg.share;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.TokenExpiredException;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.hankook.pg.exception.AuthException;
import com.hankook.pg.content.login.dto.TokenDto;
import com.hankook.pg.share.entity.AccountEntity;
import lombok.extern.slf4j.Slf4j;
import org.joda.time.DateTime;

import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;


@Slf4j
public class JWTUtil {

  private JWTUtil() {
    throw new IllegalStateException("Utility class");
  }

  private static final String CLAIM_USR_ID_KEY = "id";
  private static final String CLAIM_USR_NAME = "name";
  private static final String CLAIM_ROLE = "role";
  private static final String CLAIM_ORGN_CODE = "orgnCode";
  private static final String SECRET_KEY = "skb-calc";
  private static final String SECRET_ISSUER = "SKB";
  private static final String ACCESSTOKEN_KEY = "x-auth-token";
  private static final int EXP_MIN = 60;

  public static TokenDto getTokenDto(String token) throws AuthException {
    try {
      DecodedJWT jwt = convertToDecodeJwt(token);
      TokenDto tokenDto = new TokenDto();
      tokenDto.setId(jwt.getClaim(CLAIM_USR_ID_KEY).asString());
      tokenDto.setName(jwt.getClaim(CLAIM_USR_NAME).asString());
      tokenDto.setRole(jwt.getClaim(CLAIM_ROLE).asString());
      tokenDto.setOrgnCode(jwt.getClaim(CLAIM_ORGN_CODE).asString());
      return tokenDto;
    } catch (TokenExpiredException te) {
      throw new AuthException("만료된 계정 입니다.");
    } catch (Exception e) {
      e.printStackTrace();
      throw new AuthException("잘못된 인증 정보 입니다.");
    }
  }

  public static String createAccesstoken(AccountEntity accountEntity)
      throws UnsupportedEncodingException {
    DateTime dateTime = new DateTime();
    String token =
        JWT.create()
            .withIssuedAt(dateTime.toDate())
            .withIssuer(SECRET_ISSUER)
            .withClaim(CLAIM_USR_ID_KEY, accountEntity.getId())
            .withClaim(CLAIM_USR_NAME, accountEntity.getName())
            .withClaim(CLAIM_ROLE, accountEntity.getRole())
            .withClaim(CLAIM_ORGN_CODE, accountEntity.getOrgnCode())
            .withExpiresAt(dateTime.plusMinutes(EXP_MIN).toDate())
            .sign(Algorithm.HMAC256(SECRET_KEY));
    log.debug("created token : {}", token);
    return token;
  }

  private static DecodedJWT convertToDecodeJwt(String token) throws UnsupportedEncodingException {
    log.debug("received token : {}", token);
    JWTVerifier verifier =
        JWT.require(Algorithm.HMAC256(SECRET_KEY)).withIssuer(SECRET_ISSUER).build();
    return verifier.verify(token);
  }

  public static String getId(HttpServletRequest request) throws AuthException {
    String token = request.getHeader(ACCESSTOKEN_KEY);
    return getTokenDto(token).getId();
  }

  public static String getRole(HttpServletRequest request) throws AuthException {
    String token = request.getHeader(ACCESSTOKEN_KEY);
    return getTokenDto(token).getRole();
  }

  public static String getOrgnCode(HttpServletRequest request) throws AuthException {
    String token = request.getHeader(ACCESSTOKEN_KEY);
    return getTokenDto(token).getOrgnCode();
  }

  public static String getName(HttpServletRequest request) throws AuthException {
    String token = request.getHeader(ACCESSTOKEN_KEY);
    return getTokenDto(token).getName();
  }
}
