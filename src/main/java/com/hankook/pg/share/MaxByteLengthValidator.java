package com.hankook.pg.share;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.io.UnsupportedEncodingException;

/**
 * MaxByteLengthValidator
 *
 * 바이트 단위 문자열 길이 체크를 위한 Validator
 * @see <a href="https://github.com/ctc-g/sinavi-jfw/blob/master/validation/jfw-validation-core/src/main/java/jp/co/ctc_g/jse/core/validation/constraints/feature/maxbytelength/MaxByteLengthValidator.java">MaxByteLengthValidator.java</a>
 *
 * @author Kyeongjin.Kim
 * @since 2019-06-12
 */
public class MaxByteLengthValidator implements ConstraintValidator<com.hankook.pg.share.MaxByteLength, CharSequence> {

    private int size;
    private String encoding;

    public MaxByteLengthValidator() {}

    /**
     * {@inheritDoc}
     */
    @Override
    public void initialize(com.hankook.pg.share.MaxByteLength constraint) {
        this.size = constraint.value();
        this.encoding = constraint.encoding();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public boolean isValid(CharSequence suspect, ConstraintValidatorContext context) {
        if (isEmpty(suspect)) return true;
        try {
            return maxByteLength(suspect, size, encoding);
        } catch (UnsupportedEncodingException e) {
            throw new IllegalArgumentException(e);
        }
    }

    /**
     * 지정된 문자열이 빈 문자열인지 검사
     * - 빈 문자열은 <code> null </ code> 또는 길이가 <code> 0 </ code> 문자열
     * @param suspect 검사 대상
     * @return 빈 문자열의 경우에 true
     */
    private boolean isEmpty(CharSequence suspect) {
        return suspect == null || suspect.length() == 0;
    }

    /**
     * 지정된 문자열의 바이트 수가 지정된 크기와 같거나보다 작은 지 검사합니다.
     * @param suspect	검사 대상
     * @param size		크기
     * @param encoding	문자 인코딩
     * @return			크기가 같거나보다 작은 경우 true
     * @throws UnsupportedEncodingException
     */
    private boolean maxByteLength(CharSequence suspect, int size, String encoding) throws UnsupportedEncodingException {
        return suspect.toString().getBytes(encoding).length <= size;
    }
}
