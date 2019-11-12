# Standard for Health Insurance Policies (SHIP)
SHIP is a set of standards for Health Insurance Policies. The purpose of these standars is to represent, communicate and process Health Insurance Policies in an unambibuous manner so that claim settlements could happen in an automated manner, while allowing people to read and understand them without ambiguity.

Types of standards:
1. Representation: Health Insurance Policy Markup Language - A language to write and read health insurance policies accurately and without ambiguity by humans and computers.
2. Communication: Standards to communicate policy eligibility and coverage information.
3. Processing: Standards to process claims (including smart contracts) in an automated way.

*Currently, we are working on the first standard, which is to represent policies in a standard way.*

## Health Insurance Policy Markup Language (HIPML)

### Definition:
Health Policy Markup Language (HIPML): A domain specific language ([DSL](https://en.wikipedia.org/wiki/Domain-specific_language)) to represent health insurance policy contracts in a format that is human readable and machine readable.

### Goals:
- To come up with a language that can be used to communicate and process health insurance policies by claims management systems, thereby contributing to the automation of claim adjudication, patient eligibility determination, preauthorization of procedures and treatments, interoperability, etc…
- To come up with a language that could be used by computers to read insurance policies without having to interpret the non-standard textual representation, that is usually found in health insurance policy documents.
- To come up with a language could be used by humans, primarily policy writers at health insurance companies, to manage health insurance policies directly, reducing the development effort necessary in text-to-code translation, coordination and technical errors in doing so.

### Background:
The adjudication of healthcare claims is one of the problems in India (and across the world) that is not solved to the level it should, especially when the necessary technologies are available and being used in other industries like finance, telecommunications, etc... In the list of challenges that cause this, is the lack of adoption (and sometimes existence) of standards and protocols in exchanging information necessary for claim adjudication - including digital representation of policies, diagnosis, procedures, lab results, etc... This project is an attempt to create a standard for digital representation of health insurance policies.

### Why now?
As the health insurance coverage has increased in India suddenly with PMJAY [scheme](https://www.pmjay.gov.in) along with a steady growth of private insurance, the cost of manual adjudication of claims is going to increase linearly resulting in wastage of funds, delays, errors and other related issues. It is especially important now to automate claim adjudication, processing and payments to the possible extent, especially for the public insurers to sustain. Policy digitization and standardization is one step towards the solution.

### Overview:
HIPML is proposed to be a small and simple language that is meant for both humans and computers to read and understand health insurance policies for various purposes - primarily claim adjudication. The health insurance policies are usually written in plain text with the following sections:
- Policy description (including name, types, sum insured, policy period, copays, employee designations covered, etc..)
- Coverage (procedures that are covered, usually grouped into subsections)
- Definitions (Defining medical and administrative words and phrases used in policy document for clarity and to avoid misunderstanding)
- Exclusions (A list of medical conditions, procedures and services that are not covered)
- Conditions (For policy eligibility, claim submission, payments, arbitration details, etc..)
- Contact details
- Other administrative and legal details

### Existing standards for Insurance policies:
- [FHIR InsurancePlan resource](https://www.hl7.org/fhir/insuranceplan.html): The international standards organization for healthcare data interoperability, HL7, has been working on various standards for data exchange in healthcare domain. But, the work on standardization of Insurance Plans is still not developed enough to use and does not suit the needs very well in its current form. For example, if a benefit is covered only under certain conditions, it could not be represented easily in FHIR InsurancePlan resources. Similarly if the benefit amount for a procedure is a function(sum insured, days of treatment, plan sub-type, patient’s relationship with subscriber, employee’s designation, etc…), then it is not possible to represent that in this resource in its current version (FHIR R4 v4.0.0).
- [Actulus Modeling Language](http://hjemmesider.diku.dk/~grue/papers/aml/aml.pdf): There has been a successful attempt to create a DSL for writing insurance policies in Denmark, but (i) it is primarily focused on life insurance and pensions and (ii) it is meant for “modeling” insurance policies by insurance modelers who are mostly statisticians and not legal people who write policies.

So, the need to create HIPML arises especially keeping in mind the changes in the health insurance sector in India.

### Design choices:
Health insurance policy documents, at least the most important parts, are technically a set of rules for eligibility and coverage on top of defined entities (like We pay you X% of “Sum Insured” for treatment Y if the hospitalization has occurred and is more than Z days). If we are to develop a DSL, that is primarily meant for machines and software programmers (like most of FHIR standards), to write entity definitions and rules, we could choose something like XML/JSON + XSLT or equivalent. Even better, we could use programming-language-neutral [pseudo code](https://en.wikipedia.org/wiki/Pseudocode#Machine_compilation_of_pseudocode_style_languages) to write these rules, which could be parsed by computer programs. But, the challenge here is to make it usable (not just readable) by policy writers who are mostly non-programmers. This leads us to design a simple language that is english-like, easily memorized and using fewer special characters that are not typically used in written English.

### [HIPML Specification](https://gitlab.com/gopi.vitraya/policy-markup-language/blob/master/Specification.md)

### HIPML in practice:
Insurers write policies in HIPML using HIPML editors. The generated policy documents along with some input parameters would be parsed by computer programs to determine the eligibility and coverage rules. The HIPML parsing libraries in various programming languages would be part of this project and published along with the spec.

*Illustration:*

![](https://docs.google.com/drawings/d/e/2PACX-1vTxfNEo3tXDRNpHexCMv8rBbkp6-T318zqEfJEkyc62gGbbSN49sdEOnyryEKSV43jjEdQ2Vblu0VAc/pub?w=1136&h=680)

### Project Contributors
- [Vitraya Technologies](https://www.vitrayatech.com)
### Project Roadmap:

| S.No. | Milestone | Status | Notes |
|-------|-----------|--------|-------|
| 1 | HIPML Specification (Draft Proposal) | COMPLETED | v0.1.0 is ready to [view](https://gitlab.com/gopi.vitraya/policy-markup-language/blob/master/Specification.md) |
| 2 | HIPML Parser in one programming language | COMPLETED | ANTLR parser spec [available](https://github.com/vitrayagithub/hipml/blob/master/Implementation/ANTLR/HIPML.g4). This means the parsers could be generated in multiple programming languages including Java, JavaScript, Python, etc.. See [here](https://github.com/antlr/antlr4/blob/master/doc/targets.md).|
| 3 | An application built with HIPML to demonstrate its usage. | IN PROGRESS | A Policy editor with the ability to write policies, take policy variables as input and determine coverage.|
| 4 | HIPML v0.2.0 with all the sections covered for retail and group policies | TO DO | |

### License notice:
- All the code in the repository is shared under the [MIT License](https://opensource.org/licenses/MIT).

&copy; - 2019, Vitraya Technologies
