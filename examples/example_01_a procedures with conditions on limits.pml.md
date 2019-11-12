```yaml
Coverage:
Prc(Angioplasty)
Prc(Cataract):
  Limit per claim: One of the following:
      - Amt(35,000) if Var(Sum Insured) is equal to Amt(3,00,000)
          and Var(Employee Designation) is "Staff"
      - Amt(35,000) if Var(Sum Insured) is equal to Amt(5,00,000)
          and Var(Employee Designation) is "Manager"
      - Amt(43,750) if Var(Sum Insured) is equal to Amt(4,50,000)
          and Var(Employee Designation) is "Staff"
      - Amt(43,750) if Var(Sum Insured) is equal to Amt(7,50,000)
          and Var(Employee Designation) is "Manager"
      - Amt(47,250) if Var(Sum Insured) is equal to Amt(6,00,000)
          and Var(Employee Designation) is "Staff"
      - Amt(47,250) if Var(Sum Insured) is equal to Amt(10,00,000)
          and Var(Employee Designation) is "Manager"
      - 5% of Var(Sum Insured) default
```
