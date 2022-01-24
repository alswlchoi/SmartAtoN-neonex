package com.hankook.pg.security.config;

import com.hankook.pg.content.login.dto.MenuDto;
import lombok.Getter;
import lombok.Setter;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@Setter
@Getter
public class UserMenuList {
    List<MenuDto> menuList;
}
