package com.hankook.pg.exception;

public class valueRtnException extends RuntimeException {
	private static final long serialVersionUID = 1L;

    final Object value;

    public valueRtnException(Object value) {
        this.value = value;
    }

    public Object getValue() {
        return value;
    }
}
