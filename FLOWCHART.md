# 📊 System Flow & Architecture Diagram

This flowchart outlines the end-to-end data pipeline and reactive architecture of the **Student Performance Analysis System**, modeled after your reference structure:

```mermaid
flowchart TD
    %% Base styling matching reference flowchart
    classDef default fill:#f0f7ff,stroke:#bae6fd,stroke-width:1.5px,color:#0369a1,rx:8px,ry:8px;
    classDef topNode fill:#e0f2fe,stroke:#7dd3fc,stroke-width:2px,color:#0284c7,font-weight:bold,rx:10px,ry:10px;
    classDef engineNode fill:#e0e7ff,stroke:#a5b4fc,stroke-width:2px,color:#4338ca,font-weight:bold,rx:10px,ry:10px;
    classDef outputNode fill:#ecfdf5,stroke:#a7f3d0,stroke-width:1.5px,color:#047857,rx:8px,ry:8px;
    classDef sideNode fill:#f8fafc,stroke:#cbd5e1,stroke-width:1.5px,color:#475569,stroke-dasharray: 4 4,rx:8px,ry:8px;

    User["User"]:::topNode
    ShinyUI["Shiny Web Interface"]:::topNode
    Auth["Authentication and Session Management"]:::topNode
    Creds["Fixed Demo Credentials<br/>(admin / admin123)"]:::sideNode
    Server["Reactive Server Engine"]:::engineNode

    User --> ShinyUI
    ShinyUI --> Auth
    Auth --> Creds
    Auth --> Server

    %% Left Branch: Data Ingestion & Quality Analysis
    Ingestion["Data Ingestion and Validation"]
    OrigDataset["Original Dataset (student_data.csv)"]
    WorkingDataset["Working Dataset (30 Student Records)"]
    QualityEngine["Quality & Statistical Assessment Engine"]:::engineNode

    Server --> Ingestion
    Ingestion --> OrigDataset
    OrigDataset --> WorkingDataset
    WorkingDataset --> QualityEngine
    Server --> QualityEngine

    DimAnalysis["Dataset Dimensions dim()"]
    StructAnalysis["Dataset Structure str() & glimpse()"]
    IQROutlier["IQR Outlier Detection"]
    MathOps["Mathematical Operations<br/>(Mean, Median, Min, Max, SD)"]
    LoopGrades["R Concept: For Loop<br/>Grade Computation"]

    QualityEngine --> DimAnalysis
    QualityEngine --> StructAnalysis
    QualityEngine --> IQROutlier
    QualityEngine --> MathOps
    QualityEngine --> LoopGrades

    %% Right Branch: Regression Modeling, Visualization & Reporting
    RegEngine["Linear Regression Engine lm()"]:::engineNode
    ModelFit["Regression Modeling: Marks ~ Study_Hours"]
    RegSummary["Summary, Coefficients & R² Value"]
    Predictor["Interactive Mark & Grade Predictor"]

    VizEngine["Data Visualization Engine"]:::engineNode
    VizOperations["Exploratory Visualizations"]

    HistPlot["Histogram of Marks"]
    BoxPlot["Boxplot of Marks"]
    ScatterPlot["Scatter Plot (Hours vs Marks)"]
    BarPlot["Bar Chart of Grades"]

    DashboardResults["Dashboard KPI Cards & Explorer"]:::outputNode
    CSVGen["CSV Report Generation"]
    DownloadReports["Downloadable Reports (student_data.csv)"]:::outputNode

    Server --> RegEngine
    Server --> VizEngine

    RegEngine --> ModelFit
    ModelFit --> RegSummary
    ModelFit --> Predictor
    Predictor --> DashboardResults

    VizEngine --> VizOperations
    VizOperations --> HistPlot
    VizOperations --> BoxPlot
    VizOperations --> ScatterPlot
    VizOperations --> BarPlot

    VizOperations --> DashboardResults
    VizEngine --> CSVGen
    CSVGen --> DownloadReports
    DashboardResults --> DownloadReports
```

---

## 📌 Flowchart Components Breakdown

| Layer / Stage | Function in Project | File / Implementation |
| :--- | :--- | :--- |
| **User & Interface** | User interacts with login and analytical dashboard | `app.R` (UI Definition) |
| **Authentication** | Demo credentials verification (`admin` / `admin123`) & session logout | `app.R` (Server Auth logic) |
| **Reactive Server Engine** | Central controller handling reactivity, inputs, and triggers | `app.R` (Shiny Server function) |
| **Data Ingestion & Dataset** | Generates or loads 30 fictional student records | `generate_data.R`, `student_data.csv` |
| **Quality & Statistical Engine**| Computes `dim()`, `str()`, `glimpse()`, descriptive stats & IQR outliers | `analysis.R` & Analysis Tab |
| **R Loop Grade Engine** | Executes `for` loop to categorize students into grades (A–F) and attendance tiers | `generate_data.R`, `analysis.R` |
| **Linear Regression Engine** | Fits `lm(Marks ~ Study_Hours)`, derives $R^2 = 96.1\%$, and powers interactive slider prediction | `app.R` (Regression Tab) & `analysis.R` |
| **Visualization Engine** | Renders Histogram, Boxplot, Scatter Plot, and Bar Chart | `app.R` (Visualizations Tab) |
| **Dashboard Results & Reports** | Executive summary KPI cards, letter grade filter, and CSV download | `app.R` (Dashboard & Explorer Tabs) |

---

## 🌐 Opening the Interactive HTML Flowchart
You can also open the beautifully rendered visual version directly in your browser:
* Open file: [`docs/flowchart.html`](file:///Users/parassehgal/.gemini/antigravity/scratch/student_performance_analysis/docs/flowchart.html)
