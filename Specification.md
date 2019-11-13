## HIPML Specification:

[![Generic badge](https://img.shields.io/badge/Version-0.1.0-blue.svg)](https://shields.io/)

_This document is intended for HIPML implementers._

A health insurance policy consists of different sections with rules and conditions describing the coverage provided and not provided. HIPML’s objective is to help codify these sections and rules in a standard format. The rules are written on top of what we call entities. Examples of these entities include Diagnosis, Procedures, Hospitalization, Subscriber, Policy itself, etc..

HIPML syntax and notations:

### Types:
_Additional types will be added after the first implementation of the spec_ 
- *Number* (Integers and Floats; Eg., `500`, `-200`, `0`, `123.45`)
- *String* (`"ABC"`, `""`, `"Diabetes mellitus"`)
- *Boolean* (`True`, `False`)
- *Date* (`YYYY-MM-DD` format; `2019-11-11`)
- *Array* (Of strings, variables, currency amounts (see below); `["A", "B", "C"]`, `[Var(A), Var(B), Var(C)]`)

### Special values

- *Variables* (Input variables. `Var(Variable name)`; `Var(Sum Assured)`, `Var(Patient Age)`)
- *Currency amount* (`Amt(amount)`; `Amt(1,000)`, `Amt(5,00,000)`, `Amt(123.45)`)
- *Diagnosis* (`Dgn(Diabetes)`; This would be a predefined set of values. Mostly ICD-10 and some custom groupings. Details TBD)
- *Procedures* (`Prc(CABG)`; Same as above; ICD-10 PCS and some custom groupings)
- *Services* (`Svc(Attendant room charges)`; Non-medical services provided by the health providers that are billed, but not present in ICD-10 PCS)

### Operators:

#### Boolean
- `==` or `is` or `is equal to` (Boolean operator; `1 == 1` -> true; `"A" is equal to "B"` -> false)
- `!=` or `is not` or `is not equal to` (Boolean operator; `1 != 1` -> false; `"A" is not equal to "B"` -> true)
- `<` or `is less than` (Boolean operator on numbers and currency amount; `1 < 2` -> true; `Amt(1,000) is less than Amt(500)` -> false)
- `>` or `is greater than` (Boolean operator on numbers and currency amount; `1 > 2` -> false; `Amt(1,000) is greater than Amt(500)` -> true)
- `<=` or `is less than or equal to` (Boolean operator on numbers and currency amount; `1 <= 1` -> true; `Amt(1,000) is less than or equal to Amt(500)` -> false)
- `>=` or `is greater than or equal to` (Boolean operator on numbers and currency amount; `1 >= 2` -> false; `Amt(1,000) is greater than or equal to Amt(1000)` -> true)
- `and` (Boolean operator; Logical and; `1 == 1 and Var(Policy type) is equal to "ABC Platinum policy"`; `1 < 2 and Var(Claim Amount) >= Amt(500)`)
- `or` (Boolean operator; Logical or; `1 == 1 or "Var(Policy type) is "A"`; `1 < 2 and Var(Claim Amount) >= Amt(500)`)
- `contains` (Boolean operator on an Array of elements; `["A", "B", "C"] contains "A"` -> true)
- `does not contain` (Boolean operator on an Array of elements; `["A", "B", "C"] does not contain "A"` -> false)

#### Arithmetic
- `+`
- `-`
- `*` or `x` or `times` or `multiplied by` (Multiplication)
- `/` or `divided by` (division)
- `% of` or `percentage of` (percentage calculation)

#### Group operations

- `Minimum of` (to find the minimum of an array or a list of values; `Minimum of 1, 2 and 3` -> 1)
- `Maximum of` (to find the maximum of an array or a list of values; `Maximum of 1, 2 and 3` -> 3)
- `Whichever is lower of` (to find the mininum of two values; `Whichever is lower of 1 and 2` -> 1)
- `Whichever is higher of` (to find the maximum of two values; `Whichever if higher of 1 and 2` -> 2)

#### Date operations
- `Number of days between` (to find the number of days between two dates; `Number of days between 2019-01-01 and 2019-01-02` -> 1)
- `Number of months between` (to find the number of months between two dates; `Number of months between 2019-01-01 and 2019-02-01` -> 1)
- `Number of years between` (to find the number of years between two dates; `Number of years between 2018-01-01 and 2019-01-01` -> 1)

#### Expressions
- `All of the following are true:` (Compound boolean expression)
Usage:
```yaml
All of the following are true:
  - Var(Sum Assured) is greater than Amt(2,00,000)
  - Var(Patient Age) is less than 2
  - number of days between Var(Hospitalization Start Date) and Var(Claim Submission Date) is less than or equal to 14
```
- `All of the following are false` (Compound boolean expression; Usage similar to the above)
- `At least one of the following is true` or `Any one of the following is true` (Compound boolean expression)
Usage:
```yaml
At least one of the following is true:
  - Var(Sum Assured) is greater than Amt(3,00,000)
  - Var(Employee Designation) is "Director"
```
- `At least one of the following is false` or `Any one of the following is false` (Compound boolean expression; Usage similar to the above)
- `One of the following:` (This is used while selecting a value from a set of possible values, based on conditions. Like switch)
Usage:
```yaml
One of the following:
  - Amt(10,000) if the Var(Employee Designation) is "Intern"
  - Amt(20,000) if the Var(Employee Designation) is "Associate"
  - Amt(30,000) if the Var(Employee Designation) is "Manager"
  - Amt(5,000) default
```


### Policy Variables:
Policy variables are used while writing health insurance polices to determining coverage, exclusion and patient eligibility. These start with the prefix `Var` following by a variable name enclosed in parenteses `(Name)`. There will ve a reserved list of policy variables that are commonly used. However, custom policy variables could be used as per the requirement. The reserved keyword list will be part of the HIPML spec (Work in progress).

### Comments
- Single line comments starts with `//`
- Multi-line comments starts with `/*` and ends with `*/`

-------

Now, let us define these entities with their properties and then we go through each section of the policy to see how we can express them in HIPML.

## Entities:

### Policy: Entity to store important policy attributes

| Attribute  | Type | Description | Required |
| ------------- | ------------- | ------------- | -------------- |
| Name  | String | Name of the policy or product | Y |
| Issuer | String | Name of the insurer issuing the policy | Y |
| UIN | String | [Unique ID of the policy](https://www.irdai.gov.in/ADMINCMS/cms/NormalData_Layout.aspx?page=PageNo3832&mid=27.3.6) | N |
| Type | String | Policy type. For now only “Medical”. To be expanded | Y |
| Category | String | Policy category. “Retail” or “Group”. To be expanded | Y |
| URL | String | URL to the policy document online | N |
| Version | String | Version of the policy. E.g., 1.3.0, v4, 10, etc.. | Y |
| Approval Date | Date | Date on which the policy is approved | N |
| Effective Date | Date | Date on which the policy can be effective post policy approval | N |
| Expiration Date | Date | Date on which the policy will expire. Meaning any new policiy with a start date later than the expiration date is invalid | N |
| Sum Assured | Amount | Sum Assured | N |
| Copay % | Number | Copay percentage | N |

Custom attributes could also be introduced by the policy writer for later usage in the policy document.

### Diagnoses:

Diagnoses are represented in [ICD-10 standard](https://icd.who.int/browse10/2016/en). Common groups/categories of diagnoses, that are not present in the standard, will be part of HIPML spec.

The diagnosis or diagnosis groups are represented in their unique names as per ICD-10 or as listed in the spec in case of groupings. The format is `Dgn(Unique Name of Diagnosis or a Diagnosis group)`.

Examples:

```yaml
// ICD-10
Dgn(Meningitis in mycoses)
// Diagnosis group
Dgn(Heart surgeries)
```
### Procedures:

Procedures are represented in [ICD-10 PCS standard](https://www.cms.gov/Medicare/Coding/ICD10/2019-ICD-10-PCS.html). Common groups/categories of procedures, that are not present in the standard, will be part of HIPML spec. The format to specify a procedure or a grouping is `Prc(Unique Name of the Procedure or Procedure Grouping)`

Examples:

```yaml
// ICD-10 PCS
Prc(Bone Marrow with Synthetic Substitute)
// Procedure Group
Prc(Bone Marrow Cancer treatments)
```

### Services:

Services that are not part of ICD-10 PCS procedures will be defined as part of the spec. They are formatted as `Svc(Unique service name)`.

Examples:

```yaml
Svc(Accomodation for guardians accompanying an Insured Child)
Svc(Laundry Chrages)
```

-----------

Let us go through various sections of the policy and see how to represent them in HIPML

## Policy sections:

### Policy Atrributes
This section has the details of the policy as described in the Policy entity above, that together identify the policy uniquely. This section may also contain custom attributes that are used in eligibility or coverage determination.

```yaml
Policy Attributes:
  Name:   “ABC Gold Group Policy”
  Issuer: “ABC Insurance Pvt Ltd”
  UID:    “ABCDGGP12345V654321”
```

### Coverage
This section describes the benefit coverage of various procedures, diagnoses and services. Each coverage entry starts with the name of a Procedure, Diagnosis and Service that is covered, optionally followed by limits of the coverage including:
* `Limit per policy period`
* `Limit per policy year`
* `Limit per claim`
* `Limit per hospitalization instance`
* `Limit per day`
* `Limit per person`

The limits are followed by a number, amount or a numeric expression. See example below. A condition could be introduced for coverage item using the phrase `Included only if:` followed by a boolean expression.

Usage:

```yaml
Coverage:
  Prc(Endoscopy)
  Svc(Room charges)
  Prc(Angioplasty):
    Limt per claim: 1 % of Var(Sum Assured)
    Limt per policy period: Amt(1,00,000)
    Included only if: 
      Number of months between Var(Policy start date) and Var(Hospitalization start date) is greater than 12
      and Var(Pre-existing conditions) does not contain Dgn(Heart arrhythmia)
```

### Exclusions

This section describes the exclusions of procedures, diagnoses and services. There is an optional condition that could be evaluated for exclusions. The syntax is `Excluded unless:` followed by a boolean expression.

```yaml
Exclusions:
  Prc(Cosmetic Treatments)
  Prc(Dental Surgery):
    Excluded unless:
      Var(Claim Diagnoses) contains Dgn(Dental Cancer)
```

### Conditions

This section describes any conditions for patient eligibility to submit a claim and general rules for claim submission. The syntax is `Patient Eligibility:` or `Claim Admissibility:` followed by a boolean expression. See example below.
Not all the claim submission rules and procedures can be represented in HIPML. This section would be updated accordingly in the next version of the spec.

```yaml
Conditions:
  Patient Eligibility:
      Number of days between Var(Policy Expiration Date) and Var(Hospitalization Start Date) > 0
      and any one of the follwing is true
        - Var(Patient relationship with subscriber) is "Child" and Var(Patient Age) is less than 25
        - (Var(Patient relationship with subscriber) is "Self" and Var(Patient Age) is less than 65 years)
        - Var(Plan type) is "ABC Platinum Plan"
      and Var(Patient Nationality) is "Indian"
  Claim Admissibility:
      Number of days between Var(Policy Start Date) and Var(Claim Submission Date) >= 0
      and number of days between Var(Hospitalization Start Date) and Var(Claim Submission Date) is less than 15 days
      and Var(Country of treatment) is "India"
```

### Definitions

This section usually describes the medical terms used in the policy for procedures and diagnosis. Common definitions that are relevant for defining coverage rules would have to be identified and be made part of the specification either in diagnosis, procedures or services. The Definitions sections would be included as is and will not be interpreted by HIPML parsers. All the text of the Definitions sections would be enclosed between `{{` and `}}`. This means, you should avoid using those inside the Definitions' text.

```yaml
Definitions: {{
1. Any one illness: Any one illness means continuous period of illness and includes relapse within 45 days from the date of last consultation with the Hospital/Nursing Home where treatment was taken.
2. ABC Network Hospitals / Network Hospitals: ABC Network Hospitals / Network Hospitals means the Hospitals which have been empanelled by Us as per the latest version of the schedule of Hospitals maintained by Us, which is available to You on request.For updated list please visit our website.
3. ABC Diagnostic Centre: ABC Diagnostic Centre means the diagnostic centers which have been empanelled by us as per the latest version of the schedule of diagnostic centers maintained by Us, which is available to You on request.
...
}}
```

### Contact

Contac details usually found in policy documents. This may be represented as plain text, similar to "Discussions" section.

```yaml
Contact {{
Zone A:
Address: ABC St, House No. 123, City, State, PINCODE
Phone: 1234567890
Email: abc@def.com

Zone B:
...
}}
```
