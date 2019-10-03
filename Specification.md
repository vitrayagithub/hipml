## HIPML Specification:

_This document is intended for HIPML implementers._

A health insurance policy consists of different sections with rules and conditions describing the coverage provided and not provided. HIPML’s objective is to help codify these sections and rules in a standard format. The rules are written on top of what we call entities. Examples of these entities include Diagnosis, Procedures, Hospitalization, Subscriber, Policy itself, etc..

HIPML syntax and notations:
_The assumptions, words, grammar and design choices would be validated as the parser is being written for the Specification and as the spec is being evaluated by Health Insurance subject matter experts. This section would be appropriately._

### Types:
_Additional types will be added after the first implementation of the spec_ 
- `Integer`
- `Double`
- `String`
- `Boolean`
- `DateTime`
- `Array`
- `Map`

### Operators:
_Detailed descriptions will be added after the first implementation of the spec_

- `and`
- `or`
- `less_than`
- `greater_than`
- `less_than_or_equal_to`
- `greater_than_or_equal_to`
- `%_of`
- `is`
- `is_not`
- `difference_between_dates`
- `is_earlier_than`
- `is_later_than`
- `contains`
- `not_contains`

### Input Parameters:
Parameters starts with $ followed by a policy input variables. These are used in policy rules to determine eligibility and coverage. There will be a set of reserved keywords of HIPML. E.g., $SUM_INSURED, $HOSPITALIZATION_DAYS, $EMPLOYEE_COHORT, etc.. for parameters. The reserved keyword list will be part of the HIPML spec. We might also introduce custom policy parameters that advanced users could define in order to use them while writing rules of the policy.

### Notations:
- Comments start with `#`
- Sections and sub-sections in Coverage, Exclusions and Conditions are enclosed in `{}`
- New lines are used for statement separators and spaces/tabs for word/token separators
- 
-------

Now, let us define these entities with their properties and then we go through each section of the policy to see how we can express them in HIPML.

## Entities:

### Policy: Entity to store important policy attributes

| Attribute  | Type | Description | Required |
| ------------- | ------------- | ------------- | -------------- |
| Name  | String | Name of the policy or product | Y |
| Issuer | String | Name of the insurer issuing the policy | Y |
| UIN | String | [Unique ID of the policy](https://www.irdai.gov.in/ADMINCMS/cms/NormalData_Layout.aspx?page=PageNo3832&mid=27.3.6) | ? |
| Type | String | Policy type. For now only “Medical”. To be expanded | Y |
| Category | String | Policy category. “Retail” or “Group”. To be expanded | Y |
| URL | String | URL to the policy document online | N |
| Version | String | Version of the policy. E.g., 1.3.0, v4, 10, etc.. | Y |
| ApprovalDate | DateTime | Date on which the policy is approved | N |
| EffectiveDate | DateTime | Date on which the policy can be effective post policy approval | N |
| ExpirationDate | DateTime | Date on which the policy will expire. Meaning any new policiy with a start date later than the expiration date is invalid | N |

Custom elements could also be introduced by the policy writer for later usage in the policy document.

### Diagnosis:

Diagnosis are represented in [ICD-10 standard](https://icd.who.int/browse10/2016/en). Common groups/categories of diagnoses, that are not possible to represent in the standard, will be part of HIPML spec.

The diagnosis or diagnosis groups are represented in their unique names as per ICD-10 or as listed in the spec in case of groupings. The format is `DIAG."Unique Name of Diagnosis or a Diagnosis group"`.

Examples:

```yaml
#ICD-10
DIAG."Meningitis in mycoses"
#Diagnosis group
DIAG."Heart surgeries"
```
### Procedures:

Procedures are represented in ICD-10 PCS [standard](https://www.cms.gov/Medicare/Coding/ICD10/2019-ICD-10-PCS.html). Common groups/categories of procedures, that are not possible to represent in the standard, will be part of HIPML spec. The format to specify a procedure or a grouping is `PROC."Unique Name of the Procedure or Procedure Grouping"`

Examples:

```yaml
#ICD-10 PCS
PROC."Bone Marrow with Synthetic Substitute"
#Procedure Group
PROC."Bone Marrow Cancer treatments"
```

### Services:

Services that are not part of ICD-10 PCS procedures will be defined as part of the spec. They are formatted as SRVC."Unique service name".

Examples:

```yaml
SRVC."Accomodation for guardians accompanying an Insured Child"
SRVC."Laundry Chrages"
```

-----------

Let us go through various sections of the policy and see how to represent them in HIPML

## Policy sections:

### Policy Atrributes
This section has the details of the policy that together identify the policy uniquely. This section may also contain attributes that are used in eligibility or coverage determination.

```yaml
Policy Attributes {
  Name:   “ABC Gold Group Policy”
  Issuer: “ABC Insurance Pvt Ltd”
  UID:    “ABCDGGP12345V654321”
  …
}
```

### Coverage
This section describes the benefit coverage of various procedures, procedure groups and services. Each coverage has two components - maximum amount allowed and any conditions that needs to be evaluated.

```yaml
Coverage {
  PROC."Angioplasty" {
    MaxAmount: 1 %_of $SUM_INSURED
    conditions: 
      $HOSPITALIZATION_OCCURED
      and $POLICY_PERIOD is_greater_than 1 year
  }
}
```

### Exclusions

This section describes the exclusions of procedures, procedure groups and services. There is an optional conditional that could be evaluated for exclusions.

```yaml
Exclusions {
  PROC."Cosmetic Treatments"
  PROC."Dental Surgery" {
    unless:
      $CLAIM_DIAGNOSIS_CODES contains DIAG."Dental Cancer"
  }
}
```

### Definitions

This section usually describes the medical terms used in the policy for procedures and diagnosis. Common definitions that are relevant for defining coverage rules would be identified and be made part of the specification either in diagnosis, procedures or services.

In addition to that, The Definitions sections could be included as is and will not be interpreted by HIPML parsers.

```yaml
Definitions {
1. Any one illness: Any one illness means continuous period of illness and includes relapse within 45 days from the date of last consultation with the Hospital/Nursing Home where treatment was taken.
2. ABC Network Hospitals / Network Hospitals: ABC Network Hospitals / Network Hospitals means the Hospitals which have been empanelled by Us as per the latest version of the schedule of Hospitals maintained by Us, which is available to You on request.For updated list please visit our website.
3. ABC Diagnostic Centre: ABC Diagnostic Centre means the diagnostic centers which have been empanelled by us as per the latest version of the schedule of diagnostic centers maintained by Us, which is available to You on request.
...
}
```

### Conditions

This section describes any conditions for patient eligibility to submit a claim and general rules for claim submission. Not all the claim submission rules and procedures can be represented in HIPML. This is still being discussed.

```yaml
Conditions {
  PatientEligibility {
    conditions:
      $POLICY_EXPIRATION_DATE is_later_than $HOSPITALIZATION_ADMISSION_DATE
      and (
        ($PATIENT_RELATIONSHIP_WITH_SUBSCRIBER is "Child" and $PATIENT_AGE less_than 30 years)
        or ($PATIENT_RELATIONSHIP_WITH_SUBSCRIBER is "Self" and $PATIENT_AGE less_than 65 years)
        or $POLICY_PLANTYPE is "ABC Platinum Plan"
      )
      and $PATIENT_NATIONALITY is "Indian"
      ....
  }
  ClaimAdmissibility {
    conditions:
      $CLAIM_SUBMISSION_DATE is_greater_than $HOSPITALIZATION_ADMISSION_DATE
      and difference_between_dates($HOSPITALIZATION_DISCHARGE_DATE, $CLAIMSUBMISSION_DATE) is_less_than 15 days
      and $TREATMENT_LOCATION_COUNTRY is "India"
  }
}
```

### Contact

Not very useful for claims management system, but may be represented as plain text, similar to "Discussions" section.

```yaml
Contact {
Zone A:
Address: ABC St, House No. 123, City, State, PINCODE
Phone: 1234567890
Email: abc@def.com

Zone B:
...
}
```
