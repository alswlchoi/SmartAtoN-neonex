package com.hankook.pg.content.admin.tire.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class Wheel {
    private String barcodeNo;
    private String wheelSize;
    private String project;
    private String maker;
    private double wheelOffSet;
    private double hub;
    private double hole;
    private double pcd;
    private String locaky;
    private String locakyName;
}
