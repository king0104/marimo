package com.ssafy.marimo.common.aspect;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Aspect
@Component
public class ExecutionTimeAspect {

    @Around("@annotation(com.ssafy.marimo.common.annotation.ExecutionTimeLog)")
    public Object logExecutionTime(ProceedingJoinPoint joinPoint) throws Throwable {
        long start = System.currentTimeMillis();

        Object result = joinPoint.proceed(); // 메서드 실행

        long end = System.currentTimeMillis();
        long duration = end - start;

        String methodName = joinPoint.getSignature().toShortString();
        log.info("[ExecutionTime] {} executed in {} ms", methodName, duration);

        return result;
    }
}

