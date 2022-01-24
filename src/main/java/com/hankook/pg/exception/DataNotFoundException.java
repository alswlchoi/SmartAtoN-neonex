package com.hankook.pg.exception;

/**
 * DataNotFoundException
 * - 조회 결과가 없을 경우 예외
 *
 * @author Kyeongjin.Kim
 * @since 2019-06-26
 */
public class DataNotFoundException extends RuntimeException {

    /**
     * Constructs a new runtime exception with {@code null} as its
     * detail message.  The cause is not initialized, and may subsequently be
     * initialized by a call to {@link #initCause}.
     */
    public DataNotFoundException() {
    }

    /**
     * Constructs a new runtime exception with the specified detail message.
     * The cause is not initialized, and may subsequently be initialized by a
     * call to {@link #initCause}.
     *
     * @param message the detail message. The detail message is saved for
     *                later retrieval by the {@link #getMessage()} method.
     */
    public DataNotFoundException(String message) {
        super(message);
    }
}
