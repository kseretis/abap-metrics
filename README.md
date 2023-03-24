# Abap Metrics tool (abap-metrics)
This project contains a program written in SAP ABAP that calculates important metrics for software engineering projects. The purpose of the program is to provide a convenient and automated way to measure key aspects of software development, such as code complexity, maintainability, and efficiency.

## Metrics
The program takes into account a variety of factors, such as:
* Lines of Code (LoC)
* Number of Comments (NoC)
* Number of Pragmas (NoP)
* Number of Statements (NoS)
* Number of Authors (Authors)
* Complexity of Condition (COM)
* Complexity Weighted by Decision Depth (Depth)
* Coupling Beetwen Objects (CBO)
* Lack of Cohesion in Methods (LCOM2)

## Dependencies
* Since Version 1.00 - SAP NetWeaver 7.40 SP8 or higher
* [abapGit](https://abapgit.org/)

## Instalation
1. Clone repository using abapGit
2. Activate the objects

## Execution
1. Look for `"z_abap_metrics"` program in `SE38`/`SE80`/Eclipse ADT and execute
2. Analyse a single class or a full package
3. Choose the level of calculation, static method calls for the CBO and the aggregation type

## Good to know
Exept from the main program, the classes, some data elements and structures, an enhancement is being created in the local class `"cl_calc_code_metrics"` of the standard program `"Code Metric Tool (/SDF/CD_CUSTOM_CODE_METRIC)"`, at the end of the method `"calc_code_metric_for_object"`. The purpose of this enhancement is to extract a list of the classes for analysis and their source code. It's a key functionality of the program. 
