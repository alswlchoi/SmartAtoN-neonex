package com.hankook.pg.exception;

/**
 * FileHandleException
 * - 파일 조작과 관련된 예외
 *
 * @author Kyeongjin.Kim
 * @since 2019-06-28
 */
public class FileHandleException extends RuntimeException {
    /**
     * Constructs a new runtime exception with {@code null} as its
     * detail message.  The cause is not initialized, and may subsequently be
     * initialized by a call to {@link #initCause}.
     */
    public FileHandleException() {
        super();
    }

    /**
     * Constructs a new runtime exception with the specified detail message.
     * The cause is not initialized, and may subsequently be initialized by a
     * call to {@link #initCause}.
     *
     * @param message the detail message. The detail message is saved for
     *                later retrieval by the {@link #getMessage()} method.
     */
    public FileHandleException(String message) {
        super(message);
    }
}
