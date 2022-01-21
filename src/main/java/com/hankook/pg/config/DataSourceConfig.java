package com.hankook.pg.config;

import com.zaxxer.hikari.HikariDataSource;
import org.apache.ibatis.session.ExecutorType;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.type.JdbcType;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import javax.sql.DataSource;

@Configuration
@MapperScan(basePackages = "com.hankook.pg.content.**.dao")
public class DataSourceConfig {

    @Bean
    @Primary
    @ConfigurationProperties(prefix = "spring.datasource.hikari")
    public DataSource dataSource() {
        return new HikariDataSource();
    }

    @Bean
    @Primary
    public SqlSessionFactory sessionFactory(DataSource dataSource, ApplicationContext applicationContext) throws Exception {
        SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
        sqlSessionFactoryBean.setDataSource(dataSource);
        // 쿼리 위치 설정
        sqlSessionFactoryBean.setMapperLocations(applicationContext.getResources("classpath:query/**/*.xml"));
        sqlSessionFactoryBean.getObject().getConfiguration().setJdbcTypeForNull(JdbcType.NULL);
        sqlSessionFactoryBean.getObject().getConfiguration().setMapUnderscoreToCamelCase(true);
        sqlSessionFactoryBean.getObject().getConfiguration().setCacheEnabled(true);
        sqlSessionFactoryBean.getObject().getConfiguration().setDefaultStatementTimeout(60);
        sqlSessionFactoryBean.getObject().getConfiguration()
                .setDefaultExecutorType(ExecutorType.REUSE);
        return sqlSessionFactoryBean.getObject();

    }

    @Bean
    public DataSourceTransactionManager dataSourceProdTxManager() {
        return new DataSourceTransactionManager(dataSource());
    }
}
