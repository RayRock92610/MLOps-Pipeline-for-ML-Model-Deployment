# System Architecture Overview

This document provides a high-level overview of the system architecture, including the main components and how they interact.

## Architecture Diagram

```mermaid
flowchart LR
    subgraph Client
        U[User Browser / Mobile App]
    end

    subgraph Edge[Edge / Delivery]
        CDN[CDN]
        LB[Load Balancer]
    end

    subgraph Backend[Backend Services]
        API[API Gateway]
        SVC1[Auth Service]
        SVC2[Application Service]
        SVC3[Reporting Service]
    end

    subgraph Data[Data Layer]
        DB[(Primary Database)]
        CACHE[(Cache)]
        QUEUE[(Message Queue)]
        LOGS[(Logging / Metrics)]
    end

    U -->|HTTPS| CDN --> LB --> API
    API --> SVC1
    API --> SVC2
    API --> SVC3

    SVC1 --> DB
    SVC2 --> DB
    SVC2 --> CACHE
    SVC3 --> DB
    SVC3 --> QUEUE

    SVC1 --> LOGS
    SVC2 --> LOGS
    SVC3 --> LOGS
```

## Component Descriptions

The **Client** group represents end users accessing the system from web or mobile applications over HTTPS.  

The **Edge / Delivery** group includes the CDN for caching static assets and the load balancer for distributing incoming traffic across backend instances.  

The **Backend Services** group contains the API Gateway as the single entry point for client requests, which routes calls to internal microservices such as authentication, core application logic, and reporting.  

The **Data Layer** includes the main transactional database, a cache for frequently accessed data, a message queue for asynchronous processing, and logging/metrics infrastructure for observability.