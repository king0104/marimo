package com.ssafy.marimo.common.converter;

import com.ssafy.marimo.common.annotation.CurrentMemberId;
import com.ssafy.marimo.common.util.IdEncryptionUtil;
import com.ssafy.marimo.common.util.JWTUtil;
import com.ssafy.marimo.member.service.CustomUserDetails;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.core.MethodParameter;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

public class CurrentMemberIdArgumentResolver implements HandlerMethodArgumentResolver {

    private final IdEncryptionUtil idEncryptionUtil;

    public CurrentMemberIdArgumentResolver(IdEncryptionUtil idEncryptionUtil) {
        this.idEncryptionUtil = idEncryptionUtil;
    }

    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        return parameter.hasParameterAnnotation(CurrentMemberId.class)
                && parameter.getParameterType().equals(Integer.class);
    }

    @Override
    public Object resolveArgument(MethodParameter parameter,
                                  ModelAndViewContainer mavContainer,
                                  NativeWebRequest webRequest,
                                  WebDataBinderFactory binderFactory) throws Exception {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof CustomUserDetails) {
            CustomUserDetails userDetails = (CustomUserDetails) principal;
            String encryptedMemberId = userDetails.getEncryptedMemberId();
            // 복호화하여 Integer로 반환
            return idEncryptionUtil.decrypt(encryptedMemberId);
        }
        return null;
    }
}
