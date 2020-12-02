# This folder includes a serie of Mock components in order to :

- check the topology designer with various types (nodes, relations, data types, ..)
- checking the full Stack (A4C and its orchestrator) is running correctly, in particular with the deployments
- topology samples with the different mock components
- prefix all types in this csar with this path

Components
==========

Abstract mocktypes
- AbstractMock
- AbstractMockComponent 
- AbstractMockHost
- SampleMockAbstract
All types to be uses are derived from one of them

Concret mocktypes derived from AbstrackMock type
- BashMock : a software component that hosts MockComponent
- SleepingAtStopBashMock : a software component that hosts MockComponent.
- MiniBashFailFastMock : a mock that implements juste minimum operations to fast start & stop.
- MiniBashMock : a mock that implements juste minimum operations to fast start & stop.
- FailAtStartBashMock : a mock that fails at start step
- FailAtStopBashMock : : a mock that fails at stop step

Mock types derived from BashMock Type
- CustomCommandFailedBashMock 
- BashMockComplex : a Mock type with bash implementations, with a complex property with datas displayed at create step.
- CustomCommandBashMock : asoftware component that hosts MockComponent with 2 operations, standard create and custm operation.
- BashMockComplexProperties  :a Mock type with a complex property with all default values set to ""
- BashWfInputMock : A Mock type  with a custom operation displaying some of its properties
- BashExtendedMock : a Mock types with bash implementations with a relation types which fails at all time
- bashArtifact : Mock types with bash implementations, that has 3 artifacts of all types (http, maven, git)
- bashSpecialCharacters :a Mock type with special characters in the properties description
- bashWithPropertyNameForbidden : a Mock typs with bash implementations with description of a property with special characters


Version of components
=======

2.2.0-SNAPSHOT

Details
=======
- Components with various complexity of properties
- Topologies with various complexity of workflows (install, undinstall, run, custom workflows)
  - includes success and failed cases
- Custom commands execution
- Deployment updates
