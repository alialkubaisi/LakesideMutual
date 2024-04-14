package com.lakesidemutual.customercore.interfaces.configuration;

import javax.servlet.Filter;

import org.h2.server.web.WebServlet;
import org.springframework.boot.web.servlet.ServletRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.filter.ShallowEtagHeaderFilter;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * The WebConfiguration class is used to customize the default Spring MVC
 * configuration.
 */
@Configuration
public class WebConfiguration implements WebMvcConfigurer {
	/**
	 * This web servlet makes the web console of the H2 database engine available at
	 * the "/console" endpoint.
	 */
	@Bean
	public ServletRegistrationBean<WebServlet> h2servletRegistration() {
		ServletRegistrationBean<WebServlet> registrationBean = new ServletRegistrationBean<>(new WebServlet());
		registrationBean.addUrlMappings("/console/*");
		return registrationBean;
	}

	/**
	 * This is a filter that generates an ETag value based on the content of the
	 * response. This ETag is compared to the If-None-Match header
	 * of the request. If these headers are equal, the response content is not sent,
	 * but rather a 304 "Not Modified" status instead.
	 */
	@Bean
	public Filter shallowETagHeaderFilter() {
		return new ShallowEtagHeaderFilter();
	}

	@Override
	public void addCorsMappings(CorsRegistry registry) {
		registry.addMapping("/**")
				.allowedOrigins("https://lakesidemutualcore-production.up.railway.app", "http://localhost:3000",
						"http://localhost:8110", "http://localhost:8080", "localhost:8100", "https://lakesidemutualbackend-production-f91e.up.railway.app:8110", "https://lakesidemutualbackend-production-f91e.up.railway.app")
				.allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
				.allowedHeaders("*")
				.allowCredentials(true);

		// Specifically for Swagger UI
		registry.addMapping("/v3/api-docs/**")
				.allowedOrigins("https://lakesidemutualcore-production.up.railway.app", "http://localhost:3000")
				.allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
				.allowedHeaders("*")
				.allowCredentials(true);
	}
}