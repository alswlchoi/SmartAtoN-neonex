package com.hankook.pg.share;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.*;

/**
 * MaxByteLength
 *
 * 바이트 단위 문자열 길이 체크를 위한 Annotation
 *
 * @see <a href="https://github.com/ctc-g/sinavi-jfw/blob/master/validation/jfw-validation-core/src/main/java/jp/co/ctc_g/jse/core/validation/constraints/MaxLength.java">MaxLength.java</a>
 *
 * @author Kyeongjin.Kim
 * @since 2019-06-12
 */
@Documented
@Target({ElementType.METHOD, ElementType.FIELD, ElementType.ANNOTATION_TYPE, ElementType.CONSTRUCTOR, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = {MaxByteLengthValidator.class})
public @interface MaxByteLength {

    /**
     * 기본 에러 메시지 설정
     */
    String message() default "must be max {value} bytes";
    /**
     * 검증 그룹 지정
     */
    Class<?>[] groups() default {};
    /**
     * 페이로드를 지정
     * - 기본 검증 절차에서는는 사용하지 않음
     */
    Class<? extends Payload>[] payload() default {};
    /**
     * 기대하는 바이트 값
     */
    int value();
    /**
     * 바이트로 취득하는 기본 문자코드 값 지정
     */
    String encoding() default "UTF-8";
    /**
     * {@link MaxByteLength} 배열 지정
     * 제약조건을 여러개 지정할 경우 사용
     */
    @Retention(RetentionPolicy.RUNTIME)
    @Target({ElementType.METHOD, ElementType.FIELD, ElementType.ANNOTATION_TYPE, ElementType.CONSTRUCTOR, ElementType.PARAMETER})
    @Documented
    @interface List {
        MaxByteLength[] value();
    }

}
