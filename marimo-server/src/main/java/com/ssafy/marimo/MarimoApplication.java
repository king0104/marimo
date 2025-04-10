package com.ssafy.marimo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

@EnableCaching
@SpringBootApplication
public class MarimoApplication {

	public static void main(String[] args) {
		SpringApplication.run(MarimoApplication.class, args);
	}

}
