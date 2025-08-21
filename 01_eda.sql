-- Call Center Analytics with Snowflake Cortex AI

-- EDA
USE DATABASE call_center_db;
USE SCHEMA analytics;
SELECT * FROM call_analysis;

-- Key Summary
SELECT 
    COUNT(*) as total_calls,
    ROUND(AVG(sentiment_score), 3) as avg_sentiment,
    ROUND(AVG(agent_performance_score), 1) as avg_agent_score,
    COUNT(DISTINCT handler_id) as unique_agents,
    COUNT(DISTINCT primary_intent) as unique_call_types
FROM call_analysis;

-- Agent performance
SELECT 
    handler_id,
    COUNT(*) as total_calls,
    ROUND(AVG(sentiment_score), 3) as avg_sentiment,
    ROUND(AVG(agent_performance_score), 1) as avg_performance_score,
    
    -- Resolution effectiveness
    SUM(CASE WHEN issue_resolved = 'yes' THEN 1 ELSE 0 END) as resolved_calls,
    ROUND(SUM(CASE WHEN issue_resolved = 'yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) as resolution_rate,
    
    -- Customer satisfaction
    SUM(CASE WHEN customer_satisfaction = 'satisfied' THEN 1 ELSE 0 END) as satisfied_customers,
    ROUND(SUM(CASE WHEN customer_satisfaction = 'satisfied' THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) as satisfaction_rate,
    
    -- Escalation patterns
    SUM(CASE WHEN escalation_required = 'yes' THEN 1 ELSE 0 END) as escalations,
    ROUND(SUM(CASE WHEN escalation_required = 'yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) as escalation_rate
    
FROM call_analysis
GROUP BY handler_id
ORDER BY avg_performance_score DESC;

-- Escalation & resolution rate, customer satisfaction
%sql
WITH call_patterns AS (
    SELECT 
        primary_intent,
        urgency_level,
        COUNT(*) as call_count,
        ROUND(AVG(sentiment_score), 3) as avg_sentiment,
        ROUND(AVG(agent_performance_score), 1) as avg_agent_score,
        
        -- Resolution patterns
        ROUND(SUM(CASE WHEN issue_resolved = 'yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) as resolution_rate,
        
        -- Satisfaction patterns
        ROUND(SUM(CASE WHEN customer_satisfaction = 'satisfied' THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) as satisfaction_rate,
        
        -- Escalation patterns
        ROUND(SUM(CASE WHEN escalation_required = 'yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) as escalation_rate
        
    FROM call_analysis
    WHERE primary_intent IS NOT NULL AND primary_intent != 'Not Available'
    GROUP BY primary_intent, urgency_level
)
SELECT 
    primary_intent,
    urgency_level,
    call_count,
    avg_sentiment,
    avg_agent_score,
    resolution_rate,
    satisfaction_rate,
    escalation_rate,
    
    -- Create a flag with bright emojis to quickly identify performance issues
    CASE 
        WHEN resolution_rate < 70 THEN '⚠️ Low Resolution'
        WHEN satisfaction_rate < 60 THEN '⚠️ Low Satisfaction'
        WHEN escalation_rate > 30 THEN '⚠️ High Escalation'
        ELSE '✅ Good Performance'
    END as flag
    
FROM call_patterns
ORDER BY call_count DESC;