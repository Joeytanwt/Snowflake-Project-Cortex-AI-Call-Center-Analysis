# Call Center Analytics with Snowflake Cortex AI
## Project Overview
At my current job, our call center operations are supported by remote agents in the Philippines. For this project, I used Snowflake’s Cortex AI to transcribe call recordings and analyse call intent, urgency, issue resolution, customer satisfaction, and agent performance.

This project and its code are designed to run within Snowflake and Notebooks, which support executing both SQL queries and Python code in the same environment.

🔗 [Link](https://public.tableau.com/views/CallCenterAnalysis_17557566296100/CallCenterPerformanceDashboard?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link) to interactive dashboard on Tableau Public
## Steps
### 00_setup.ipynb
* Database, schema, and stage initialisation
* Audio file ingestion
* Transcription pipeline
* Transcript and agent analysis with Snowflake Cortex AI

### 01_eda.sql
* Exploratory SQL for core metrics
* Agent and call segmentation
* Satisfaction, escalation, and flagging logic

### 02_visualisation.png
* Tableau dashboard of key metrics
* Word clouds with stopwords removed for sharper business insights
* Agent performance plot
