# KK Payments SLI/SLO Document

## Purpose

This document defines how the reliability of the KK Payments service is measured and when an automatic rollback should occur.

---

# SLI 1 – Availability

### Measurement

- Data Source: Health endpoint (/health)
- Method: Successful health checks ÷ Total health checks × 100
- Measurement Window: 30 Days

### SLO

- Target: 99.9% availability over 30 days

---

# SLI 2 – Response Time

### Measurement

- Data Source: Nginx access logs
- Method: Average response time of payment requests
- Measurement Window: 30 Days

### SLO

- Target: 95% of requests complete in under 500ms

---

# SLI 3 – Payment Error Rate

### Measurement

- Data Source: Application logs
- Method: Failed payment requests ÷ Total payment requests × 100
- Measurement Window: 30 Days

### SLO

- Target: Error rate below 1%

---

# Rollback Thresholds

| SLI | SLO Target | Rollback Trigger |
|------|------------|------------------|
| Availability | 99.9% | Health checks fail for 60 seconds |
| Response Time | 95% < 500ms | Average response time exceeds 2 seconds |
| Error Rate | <1% | Error rate exceeds 5% |

---

# Out of Scope

The following metrics are not part of these SLOs.

## CPU Usage

CPU usage may become high during heavy traffic without affecting customers.

## Memory Usage

Memory consumption alone is not used to trigger rollbacks because it does not always indicate service failure.