package com.hankook.pg.share;

import org.apache.commons.lang3.StringUtils;

import java.net.InetAddress;
import java.net.UnknownHostException;

public class CheckIpRange {

  private CheckIpRange(){
    throw new IllegalStateException("Utility class");
  }

  public static boolean isValidRange(String ipStart, String ipEnd, String ipToCheck) {
    if (StringUtils.isBlank(ipStart) || StringUtils.isBlank(ipEnd)) {
      return true;
    }
    try {
      long ipLo = ipToLong(InetAddress.getByName(ipStart));
      long ipHi = ipToLong(InetAddress.getByName(ipEnd));
      long ipToTest = ipToLong(InetAddress.getByName(ipToCheck));
      return ipToTest >= ipLo && ipToTest <= ipHi;
    } catch (UnknownHostException e) {
      return false;
    }
  }

  private static long ipToLong(InetAddress ip) {
    byte[] octets = ip.getAddress();
    long result = 0;
    for (byte octet : octets) {
      result <<= 8;
      result |= octet & 0xff;
    }
    return result;
  }

}
