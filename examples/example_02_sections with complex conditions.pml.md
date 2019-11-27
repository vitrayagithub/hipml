```yaml
Policy Attributes:
  Name: "ABC Gold Health Policy"
  Issuer: "ABC Insurance Corporation"
  UIN: "ABC123DEF456"
  Type: "Medical"
  Category: "Group"
  URL: "https://www.abchealth.com/policy/abcGoldHealthPolicy.html"
  Version: "1.0.0"
  Approval Date: 2019-01-01
  Effective Date: 2019-02-01
  Expiration Date: 2024-12-31
  Sum Insured: One of the following:
    - Amt(1,00,000) if Var(Employee Designation) is "Staff"
        and Var(Enhancement Type) is "50%"
    - Amt(2,00,000) if Var(Employee Designation) is "Associate"
    - Amt(2,00,000) if Var(Employee Designation) is "Director"
    - Amt(50,000) default
  Copay %: 10

Coverage:
  Prc(CABG):
    Limit per policy period: Amt(1,00,000)
  Dgn(Heart diseases), Prc(Cancer Treatments):
    Limit per person: Amt(5,00,000)
  Prc(Cataract):
    Limit per claim: One of the following:
        - Amt(35,000) if all of the following are true:
            - Var(Employee Designation) is "Staff"
            - Var(Enhancement Type) is "50%"
        - Amt(40,000) if Var(Employee Designation) is "Asociate"
            and Var(Enhancement Type) is "100%"
        - Amt(50,000) if Var(Employee Designation) is "Director"
        - 5 % of Var(Sum Insured) default
    Included only if:
      number of months between Var(Policy start date) and Var(Hospitalization date) is greater than 36
      and Var(Pre-existing conditions) does not contain Dgn(Diabetes)

Exclusions:
  Dgn(Ebola)
  Svc(Room rent for attendants)
  Prc(Minimally invasive CABG):
    Excluded unless: Var(Employee Designation) is "Director"
```
