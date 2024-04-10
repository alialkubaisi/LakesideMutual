package com.lakesidemutual.customercore.interfaces.configuration;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * The SwaggerConfiguration class configures the HTTP resource API documentation.
 */
@Configuration
public class SwaggerConfiguration {

	@Bean
	public OpenAPI customerSelfServiceApi() {
		return new OpenAPI()
				.info(new Info().title("Customer Core API")
						.description("This API allows clients to create new customers and retrieve details about existing customers.")
						.version("v1.0.0")
						.license(new License().name("Apache 2.0")));
	}

	@Bean
	public WebMvcConfigurer corsConfigurer() {
		return new WebMvcConfigurer() {
			@Override
			public void addCorsMappings(CorsRegistry registry) {
				registry.addMapping("/**")
						.allowedOrigins("https://lakesidemutualcore-production.up.railway.app")
						.allowedMethods("GET", "POST", "PUT", "DELETE")
						.allowedHeaders("*")
						.allowCredentials(true)
						.maxAge(3600);
			}
		};
	}
}
