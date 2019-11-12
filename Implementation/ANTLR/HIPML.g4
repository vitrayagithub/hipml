grammar HIPML ;

policy : policySection+ ;

policySection : attributesSection
              | coverageSection
              | exclusionsSection
              ;
// Attributes section
attributesSection : ATTRIBUTES_SECTION_NAME ':' attributesBody ;

attributesBody : attribute+ ;

attribute : attributeString
          | attributeDate
          | attributeNumber
          ;

attributeString : ATTRIBUTES_KEY_WITH_STRING_VALUES ':' string ;

attributeDate : ATTRIBUTES_KEY_WITH_DATE_VALUES ':' date ;

attributeNumber : ATTRIBUTES_KEY_WITH_NUMBER_VALUES ':' (numberExpr | switchStmt) ;


// Coverage section
coverageSection : COVERAGE_SECTION_NAME ':' coverageBody ;

coverageBody : coverageItem+ ;

coverageItem : coverageItemName (',' coverageItemName)* (':' coverageItemDetails)? ;

coverageItemName : procedure
                 | diagnosis
                 | service
                 ;

// Either (limits and one condition) OR (limits and no condition) OR just one condition should exist
coverageItemDetails : coverageItemLimit+ coverageItemCondition
                    | coverageItemLimit+
                    | coverageItemCondition
                    ;

coverageItemLimit : COVERAGE_ITEM_LIMIT_KEY ':' (numberExpr | switchStmt) ;

coverageItemCondition : COVERAGE_ITEM_CONDITION_KEY ':' booleanExpr ;

// Exclusions section
exclusionsSection: EXCLUSIONS_SECTION_NAME ':' exclusionBody ;

exclusionBody : exclusionItem+ ;

// The item names for coverage and exclusions are the same
exclusionItem : coverageItemName (',' coverageItemName)* (':' exclusionItemCondition)? ;

exclusionItemCondition : EXCLUSIONS_ITEM_CONDITION_KEY ':' booleanExpr ;

// Switch statement - choosing one of the choices based on conditions
switchStmt: SWITCH_PREFIX switchExpr+ switchDefaultExpr ;

switchExpr : GROUP_EXPR_STMT_PREFIX (numberExpr | string) IF booleanExpr ;

switchDefaultExpr : GROUP_EXPR_STMT_PREFIX (numberExpr | string) SWITCH_DEFAULT_SUFFIX ;

// Returns boolean
booleanExpr : ALL_ARE_TRUE booleanGroupExprStmt+
            | ALL_ARE_FALSE booleanGroupExprStmt+
            | AT_LEAST_ONE_IS_TRUE booleanGroupExprStmt+
            | AT_LEAST_ONE_IS_FALSE booleanGroupExprStmt+
            | booleanExpr AND booleanExpr
            | booleanExpr OR booleanExpr
            | comparatorExpr
            | listOpExpr
            | '(' booleanExpr ')'
            ;

booleanGroupExprStmt : GROUP_EXPR_STMT_PREFIX booleanExpr;

// Returns boolean
comparatorExpr : numberExpr LT numberExpr
               | numberExpr LTE numberExpr
               | numberExpr GT numberExpr
               | numberExpr GTE numberExpr
               | numberExpr EQ numberExpr
               | numberExpr NE numberExpr
               | (variable | string) EQ (variable | string)
               | (variable | string) NE (variable | string)
               ;

groupFnExpr : (MIN | LOW_OF) numberExpr (',' numberExpr)* AND numberExpr
            | (MAX | HIGH_OF) numberExpr (',' numberExpr)* AND numberExpr
            ;

numberExpr : numberExpr MUL numberExpr
           | numberExpr DIV numberExpr
           | numberExpr PER numberExpr
           | numberExpr ADD numberExpr
           | numberExpr SUB numberExpr
           | dateExpr
           | groupFnExpr
           | variable
           | amount
           | number
           | '(' numberExpr ')'
           ;

// List operations
listOpExpr: (list | variable) (CONTAINS | DOES_NOT_CONTAIN) (number | amount | variable | date | string | procedure | diagnosis | service) ;

list : '[' listExpr ']' ;

listExpr : amount (',' amount)*
         | variable (',' variable)*
         | date (',' date)*
         | string (',' string)*
         | procedure (',' procedure)*
         | diagnosis (',' diagnosis)*
         | service (',' service)*
         ;

dateExpr : DIFF_DAYS (variable | date) AND (variable | date)
         | DIFF_MONTHS (variable | date) AND (variable | date)
         | DIFF_YEARS (variable | date) AND (variable | date)
         ;

variable : VARIABLE ;
diagnosis : DIAGNOSIS ;
procedure : PROCEDURE ;
service : SERVICE ;
amount : AMOUNT ;
date : DATE ;
number : NUMBER ;
string : STRING ;
bool : BOOLEAN ;

//-----------------------------------------
// Lexer rules
//-----------------------------------------

METADATA_SECTION_NAME    : 'Policy Metadata' ;
ATTRIBUTES_SECTION_NAME  : 'Policy Attributes' ;
COVERAGE_SECTION_NAME    : 'Coverage' ;
EXCLUSIONS_SECTION_NAME  : 'Exclusions' ;
DEFINITIONS_SECTION_NAME : 'Definitions' ;
CONTACT_SECTION_NAME     : 'Contact' ;

METADATA_KEY : 'DocType'
             | 'DocVersion'
             ;

ATTRIBUTES_KEY_WITH_STRING_VALUES : 'Name'
                                  | 'Issuer'
                                  | 'UIN'
                                  | 'Type'
                                  | 'Category'
                                  | 'URL'
                                  | 'Version'
                                  ;

ATTRIBUTES_KEY_WITH_DATE_VALUES : 'Approval Date'
                                | 'Effective Date'
                                | 'Expiration Date'
                                ;

ATTRIBUTES_KEY_WITH_NUMBER_VALUES : 'Sum Assured'
                                  | 'Copay %'
                                  ;

COVERAGE_ITEM_LIMIT_KEY : 'Limit per policy period'
                        | 'Limit per policy year'
                        | 'Limit per claim'
                        | 'Limit per hospitalization instance'
                        | 'Limit per day'
                        | 'Limit per person'
                        ;

COVERAGE_ITEM_CONDITION_KEY   : 'Included only if' ;
EXCLUSIONS_ITEM_CONDITION_KEY : 'Excluded unless' ;

VARIABLE  : 'Var' '(' ALPHABET KEYCHAR*? ')' ;
PROCEDURE : 'Prc' '(' ALPHABET KEYCHAR*? ')' ;
DIAGNOSIS : 'Dgn' '(' ALPHABET KEYCHAR*? ')' ;
SERVICE   : 'Svc' '(' ALPHABET KEYCHAR*? ')' ;

AMOUNT : 'Amt' '(' HYPHEN? DIGIT (DIGIT | ',')* ('.' DIGIT+)? ')' ;

SWITCH_PREFIX : [Oo] 'ne of the following:' ;
GROUP_EXPR_STMT_PREFIX: '- ' ;
SWITCH_DEFAULT_SUFFIX : 'if none of the above matches'
                      | 'default'
                      ;

ALL_ARE_TRUE : [Aa] 'll of the following are true:' ;
ALL_ARE_FALSE : [Aa] 'll of the following are false:' ;
AT_LEAST_ONE_IS_TRUE : [Aa] ('t least' | 'ny' ) ' one of the following is true:' ;
AT_LEAST_ONE_IS_FALSE : [Aa] ('t least' | 'ny' ) ' one of the following is false:' ;

IF  : 'if' ;
AND : 'and' ;
OR  : 'or' ;

CONTAINS: 'contains' ;
DOES_NOT_CONTAIN: 'does not contain' ;

ADD : '+' | 'plus' ;
SUB : HYPHEN | 'minus' ;
MUL : '*' | 'x' | 'times' | 'multiplied by' ;
DIV : '/' | 'divided by' ;
PER : '% of' | 'percentage of' ;

LT  : '<' | 'is less than' ;
LTE : '<=' | 'is less than or equal to' ;
GT  : '>' | 'is greater than' ;
GTE : '>=' | 'is greater than or equal to' ;
NE  : '!=' | 'is not equal to' | 'is not' ;
EQ  : '==' | 'is equal to' | 'is' ;

MIN : [Mm] 'inimum of' ;
MAX : [Mm] 'aximum of' ;
LOW_OF : [Ww] 'hichever is lower of' ;
HIGH_OF : [Ww] 'hichever is higher of' ;

DIFF_DAYS : [Nn] 'umber of days between' ;
DIFF_MONTHS : [Nn] 'umber of months between' ;
DIFF_YEARS : [Nn] 'umber of years between' ;

DATE    : [12] DIGIT DIGIT DIGIT HYPHEN [01] DIGIT HYPHEN [0123] DIGIT
        | [12] DIGIT DIGIT DIGIT '/' [01] DIGIT '/' [0123] DIGIT ;
BOOLEAN : [Tt] 'rue' | [Ff] 'alse' ;
NUMBER  : HYPHEN? DIGIT DIGIT* ('.' DIGIT+)? ;
STRING  : '"' (ESC | .)*? '"' ;

// Hyphen has to come after SUB as they match the same literal
HYPHEN : '-' ;

fragment ESC      : '\\' [btnr"\\] ;
fragment DIGIT    : [0-9] ;
fragment ALPHABET : [a-zA-Z] ;
fragment KEYCHAR  : ( ALPHABET | DIGIT | [_. -]) ;

LINE_COMMENT : '//' .*? '\r'? '\n' -> skip ;
COMMENT      : '/*' .*? '*/' -> skip ;

WS : [ \t\r\n]+ -> skip ;
