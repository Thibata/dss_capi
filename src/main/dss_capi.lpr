library dss_capi;
{$MODE Delphi}
{$APPTYPE CONSOLE}

{ ----------------------------------------------------------
  Copyright (c) 2008-2014, Electric Power Research Institute, Inc.
  All rights reserved.
  ----------------------------------------------------------

  Redistribution and use in source and binary forms, with or without modification,
  are permitted provided that the following conditions are met:
*	Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.
*	Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.
*	Neither the name of the Electric Power Research Institute, Inc.,
  nor the names of its contributors may be used to endorse or promote products
  derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY Electric Power Research Institute, Inc., "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED. IN NO EVENT SHALL Electric Power Research Institute, Inc.,
  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  POSSIBILITY OF SUCH DAMAGE.
}

{
  08/05/2008  Created from ESI DSS
}

{
	08/17/2016  Created from OpenDSS
 ----------------------------------------------------------
  Copyright (c) 2016 Battelle Memorial Institute
 ----------------------------------------------------------
}

uses
    SysUtils,
    Classes,
    CustApp,
    {$IFDEF UNIX}cwstring,{$ENDIF}
    Arraydef in 'electricdss/Source/Shared/Arraydef.pas',
    AutoAdd in 'electricdss/Source/Common/AutoAdd.pas',
    Bus in 'electricdss/Source/Common/Bus.pas',
    CableConstants in 'electricdss/Source/General/CableConstants.pas',
    CableData in 'electricdss/Source/General/CableData.pas',
    Capacitor in 'electricdss/Source/PDElements/Capacitor.pas',
    CapControl in 'electricdss/Source/Controls/CapControl.pas',
    CapControlVars in 'electricdss/Source/Controls/CapControlVars.pas',
    CapUserControl in 'electricdss/Source/Controls/CapUserControl.pas',
    Circuit in 'electricdss/Source/Common/Circuit.pas',
    CktElement in 'electricdss/Source/Common/CktElement.pas',
    CktElementClass in 'electricdss/Source/Common/CktElementClass.pas',
    CktTree in 'electricdss/Source/Shared/CktTree.pas',
    CmdForms in 'electricdss/Source/CMD/CmdForms.pas',
    Command in 'electricdss/Source/Shared/Command.pas',
    CNData in 'electricdss/Source/General/CNData.pas',
    CNLineConstants in 'electricdss/Source/General/CNLineConstants.pas',
    Conductor in 'electricdss/Source/Common/Conductor.pas',
    ConductorData in 'electricdss/Source/General/ConductorData.pas',
    ControlClass in 'electricdss/Source/Controls/ControlClass.pas',
    ControlElem in 'electricdss/Source/Controls/ControlElem.pas',
    ControlQueue in 'electricdss/Source/Common/ControlQueue.pas',
    DSSCallBackRoutines in 'electricdss/Source/Common/DSSCallBackRoutines.pas',
    DSSClass in 'electricdss/Source/Common/DSSClass.pas',
    DSSClassDefs in 'electricdss/Source/Common/DSSClassDefs.pas',
    DSSGlobals in 'electricdss/Source/Common/DSSGlobals.pas',
    DSSObject in 'electricdss/Source/General/DSSObject.pas',
    Dynamics in 'electricdss/Source/Shared/Dynamics.pas',
    EnergyMeter in 'electricdss/Source/Meters/EnergyMeter.pas',
    Equivalent in 'electricdss/Source/PCElements/Equivalent.pas',
    EventQueue in 'electricdss/Source/Common/EventQueue.pas',
    ExecCommands in 'electricdss/Source/Executive/ExecCommands.pas',
    ExecHelper in 'electricdss/Source/Executive/ExecHelper.pas',
    ExecOptions in 'electricdss/Source/Executive/ExecOptions.pas',
    Executive in 'electricdss/Source/Executive/Executive.pas',
    ExpControl in 'electricdss/Source/Controls/ExpControl.pas',
    ExportCIMXML in 'electricdss/Source/Common/ExportCIMXML.pas',
    ExportOptions in 'electricdss/Source/Executive/ExportOptions.pas',
    ExportResults in 'electricdss/Source/Common/ExportResults.pas',
    Fault in 'electricdss/Source/PDElements/Fault.pas',
    Feeder in 'electricdss/Source/Common/Feeder.pas',
    fuse in 'electricdss/Source/PDElements/fuse.pas',
    UPFCControl in 'electricdss/Source/Controls/UPFCControl.pas',
    GenDispatcher in 'electricdss/Source/Controls/GenDispatcher.pas',
    generator in 'electricdss/Source/PCElements/generator.pas',
    GeneratorVars in 'electricdss/Source/PCElements/GeneratorVars.pas',
    GenUserModel in 'electricdss/Source/PCElements/GenUserModel.pas',
    GICLine in 'electricdss/Source/PCElements/GICLine.pas',
    GICTransformer in 'electricdss/Source/PDElements/GICTransformer.pas',
    GrowthShape in 'electricdss/Source/General/GrowthShape.pas',
    HashList in 'electricdss/Source/Shared/HashList.pas',
    IniRegSave in 'electricdss/Source/Shared/IniRegSave.pas',
    InvControl in 'electricdss/Source/Controls/InvControl.pas',
    Isource in 'electricdss/Source/PCElements/Isource.pas',
    KLUSolve in 'electricdss/Source/CMD/KLUSolve.pas',
    Line in 'electricdss/Source/PDElements/Line.pas',
    LineCode in 'electricdss/Source/General/LineCode.pas',
    LineConstants in 'electricdss/Source/General/LineConstants.pas',
    LineGeometry in 'electricdss/Source/General/LineGeometry.pas',
    LineSpacing in 'electricdss/Source/General/LineSpacing.pas',
    LineUnits in 'electricdss/Source/Shared/LineUnits.pas',
    Load in 'electricdss/Source/PCElements/Load.pas',
    LoadShape in 'electricdss/Source/General/LoadShape.pas',
    mathutil in 'electricdss/Source/Shared/mathutil.pas',
    MemoryMap_lib in 'electricdss/Source/Meters/MemoryMap_lib.pas',
    MeterClass in 'electricdss/Source/Meters/MeterClass.pas',
    MeterElement in 'electricdss/Source/Meters/MeterElement.pas',
    Monitor in 'electricdss/Source/Meters/Monitor.pas',
    MyDSSClassDefs in 'electricdss/Source/CMD/MyDSSClassDefs.Pas',
    NamedObject in 'electricdss/Source/General/NamedObject.pas',
    Notes in 'electricdss/Source/Common/Notes.pas',
    OHLineConstants in 'electricdss/Source/General/OHLineConstants.pas',
    ParserDel in 'electricdss/Source/Parser/ParserDel.pas',
    PCClass in 'electricdss/Source/PCElements/PCClass.pas',
    PCElement in 'electricdss/Source/PCElements/PCElement.pas',
    PDClass in 'electricdss/Source/PDElements/PDClass.pas',
    PDElement in 'electricdss/Source/PDElements/PDElement.pas',
    PointerList in 'electricdss/Source/Shared/PointerList.pas',
    PriceShape in 'electricdss/Source/General/PriceShape.pas',
    Pstcalc in 'electricdss/Source/Shared/Pstcalc.pas',
    PVsystem in 'electricdss/Source/PCElements/PVsystem.pas',
    PVSystemUserModel in 'electricdss/Source/PCElements/PVSystemUserModel.pas',
    Reactor in 'electricdss/Source/PDElements/Reactor.pas',
    Recloser in 'electricdss/Source/Controls/Recloser.pas',
    ReduceAlgs in 'electricdss/Source/Meters/ReduceAlgs.pas',
    RegControl in 'electricdss/Source/Controls/RegControl.pas',
    Relay in 'electricdss/Source/Controls/Relay.pas',
    RPN in 'electricdss/Source/Parser/RPN.pas',
    Sensor in 'electricdss/Source/Meters/Sensor.pas',
    ShowOptions in 'electricdss/Source/Executive/ShowOptions.pas',
    ShowResults in 'electricdss/Source/Common/ShowResults.pas',
    Solution in 'electricdss/Source/Common/Solution.pas',
    SolutionAlgs in 'electricdss/Source/Common/SolutionAlgs.pas',
    Spectrum in 'electricdss/Source/General/Spectrum.pas',
    StackDef in 'electricdss/Source/Shared/StackDef.pas',
    Storage in 'electricdss/Source/PCElements/Storage.pas',
    StorageController in 'electricdss/Source/Controls/StorageController.pas',
    StorageVars in 'electricdss/Source/PCElements/StorageVars.pas',
    StoreUserModel in 'electricdss/Source/PCElements/StoreUserModel.pas',
    SwtControl in 'electricdss/Source/Controls/SwtControl.pas',
    TCC_Curve in 'electricdss/Source/General/TCC_Curve.pas',
    TempShape in 'electricdss/Source/General/TempShape.pas',
    Terminal in 'electricdss/Source/Common/Terminal.pas',
    TOPExport in 'electricdss/Source/Common/TOPExport.pas',
    Transformer in 'electricdss/Source/PDElements/Transformer.pas',
    TSData in 'electricdss/Source/General/TSData.pas',
    TSLineConstants in 'electricdss/Source/General/TSLineConstants.pas',
    Ucmatrix in 'electricdss/Source/Shared/Ucmatrix.pas',
    Ucomplex in 'electricdss/Source/Shared/Ucomplex.pas',
    UPFC in 'electricdss/Source/PCElements/UPFC.pas',
    Utilities in 'electricdss/Source/Common/Utilities.pas',
    VCCS in 'electricdss/Source/PCElements/vccs.pas',
    VSConverter in 'electricdss/Source/PCElements/VSConverter.pas',
    VSource in 'electricdss/Source/PCElements/VSource.pas',
    WireData in 'electricdss/Source/General/WireData.pas',
    XfmrCode in 'electricdss/Source/General/XfmrCode.pas',
    XYcurve in 'electricdss/Source/General/XYcurve.pas',
    Ymatrix in 'electricdss/Source/Common/Ymatrix.pas',
  
    CAPI_Utils in 'CAPI_Utils.pas',
  
    CAPI_ActiveClass in 'CAPI_ActiveClass.pas',
    CAPI_Bus in 'CAPI_Bus.pas',
    CAPI_Capacitors in 'CAPI_Capacitors.pas',
    CAPI_CapControls in 'CAPI_CapControls.pas',
    CAPI_Circuit in 'CAPI_Circuit.pas',
    CAPI_CktElement in 'CAPI_CktElement.pas',
    CAPI_CmathLib in 'CAPI_CmathLib.pas',
    CAPI_CtrlQueue in 'CAPI_CtrlQueue.pas',
    CAPI_DSS in 'CAPI_DSS.pas',
    CAPI_DSSElement in 'CAPI_DSSElement.pas',
    CAPI_DSSimComs in 'CAPI_DSSimComs.pas',
    //CAPI_DSSProgress in 'CAPI_DSSProgress.pas',
    CAPI_DSSProperty in 'CAPI_DSSProperty.pas',
    CAPI_DSS_Executive in 'CAPI_DSS_Executive.pas',
    CAPI_Error in 'CAPI_Error.pas',
    //CAPI_DSSEvents in 'CAPI_DSSEvents.pas',
    CAPI_Fuses in 'CAPI_Fuses.pas',
    CAPI_Generators in 'CAPI_Generators.pas',
    CAPI_Isources in 'CAPI_Isources.pas',
    CAPI_LineCodes in 'CAPI_LineCodes.pas',
    CAPI_Lines in 'CAPI_Lines.pas',
    CAPI_Loads in 'CAPI_Loads.pas',
    CAPI_LoadShapes in 'CAPI_LoadShapes.pas',
    CAPI_Meters in 'CAPI_Meters.pas',
    CAPI_Monitors in 'CAPI_Monitors.pas',
    CAPI_Parser in 'CAPI_Parser.pas',
    CAPI_PDElements in 'CAPI_PDElements.pas',
    CAPI_PVSystems in 'CAPI_PVSystems.pas',
    CAPI_Reclosers in 'CAPI_Reclosers.pas',
    CAPI_RegControls in 'CAPI_RegControls.pas',
    CAPI_Relays in 'CAPI_Relays.pas',
    CAPI_Sensors in 'CAPI_Sensors.pas',
    CAPI_Settings in 'CAPI_Settings.pas',
    CAPI_Solution in 'CAPI_Solution.pas',
    CAPI_SwtControls in 'CAPI_SwtControls.pas',
    CAPI_Text in 'CAPI_Text.pas',
    CAPI_Topology in 'CAPI_Topology.pas',
    CAPI_Transformers in 'CAPI_Transformers.pas',
    CAPI_Vsources in 'CAPI_Vsources.pas',
    CAPI_XYCurves in 'CAPI_XYCurves.pas',
    CAPI_YMatrix in 'CAPI_YMatrix.pas';

exports

    DSS_ResetStringBuffer,
    DSS_Dispose_PByte,
    DSS_Dispose_PDouble,
    DSS_Dispose_PInteger,
    DSS_Dispose_PPAnsiChar,
    

    ActiveClass_Get_AllNames,
    ActiveClass_Get_First,
    ActiveClass_Get_Next,
    ActiveClass_Get_Name,
    ActiveClass_Set_Name,
    ActiveClass_Get_NumElements,
    ActiveClass_Get_ActiveClassName,
    ActiveClass_Get_Count,
    Bus_Get_Name,
    Bus_Get_NumNodes,
    Bus_Get_SeqVoltages,
    Bus_Get_Voltages,
    Bus_Get_Nodes,
    Bus_Get_Isc,
    Bus_Get_Voc,
    Bus_Get_kVBase,
    Bus_Get_puVoltages,
    Bus_Get_Zsc0,
    Bus_Get_Zsc1,
    Bus_Get_ZscMatrix,
    Bus_ZscRefresh,
    Bus_Get_YscMatrix,
    Bus_Get_Coorddefined,
    Bus_Get_x,
    Bus_Set_x,
    Bus_Get_y,
    Bus_Set_y,
    Bus_Get_Distance,
    Bus_GetUniqueNodeNumber,
    Bus_Get_CplxSeqVoltages,
    Bus_Get_Int_Duration,
    Bus_Get_Lambda,
    Bus_Get_Cust_Duration,
    Bus_Get_Cust_Interrupts,
    Bus_Get_N_Customers,
    Bus_Get_N_interrupts,
    Bus_Get_puVLL,
    Bus_Get_VLL,
    Bus_Get_puVmagAngle,
    Bus_Get_VMagAngle,
    Bus_Get_TotalMiles,
    Bus_Get_SectionID,
    Capacitors_Get_AllNames,
    Capacitors_Get_First,
    Capacitors_Get_IsDelta,
    Capacitors_Get_kV,
    Capacitors_Get_kvar,
    Capacitors_Get_Name,
    Capacitors_Get_Next,
    Capacitors_Get_NumSteps,
    Capacitors_Set_IsDelta,
    Capacitors_Set_kV,
    Capacitors_Set_kvar,
    Capacitors_Set_Name,
    Capacitors_Set_NumSteps,
    Capacitors_Get_Count,
    Capacitors_AddStep,
    Capacitors_SubtractStep,
    Capacitors_Get_AvailableSteps,
    Capacitors_Get_States,
    Capacitors_Set_States,
    Capacitors_Open,
    Capacitors_Close,
    CapControls_Get_AllNames,
    CapControls_Get_Capacitor,
    CapControls_Get_CTratio,
    CapControls_Get_DeadTime,
    CapControls_Get_Delay,
    CapControls_Get_DelayOff,
    CapControls_Get_First,
    CapControls_Get_Mode,
    CapControls_Get_MonitoredObj,
    CapControls_Get_MonitoredTerm,
    CapControls_Get_Name,
    CapControls_Get_Next,
    CapControls_Get_OFFSetting,
    CapControls_Get_ONSetting,
    CapControls_Get_PTratio,
    CapControls_Get_UseVoltOverride,
    CapControls_Get_Vmax,
    CapControls_Get_Vmin,
    CapControls_Set_Capacitor,
    CapControls_Set_CTratio,
    CapControls_Set_DeadTime,
    CapControls_Set_Delay,
    CapControls_Set_DelayOff,
    CapControls_Set_Mode,
    CapControls_Set_MonitoredObj,
    CapControls_Set_MonitoredTerm,
    CapControls_Set_Name,
    CapControls_Set_OFFSetting,
    CapControls_Set_ONSetting,
    CapControls_Set_PTratio,
    CapControls_Set_UseVoltOverride,
    CapControls_Set_Vmax,
    CapControls_Set_Vmin,
    CapControls_Get_Count,
    CapControls_Reset,
    Circuit_Get_Name,
    Circuit_Get_NumBuses,
    Circuit_Get_NumCktElements,
    Circuit_Get_NumNodes,
    Circuit_Get_LineLosses,
    Circuit_Get_Losses,
    Circuit_Get_AllBusVmag,
    Circuit_Get_AllBusVolts,
    Circuit_Get_AllElementNames,
    Circuit_Get_SubstationLosses,
    Circuit_Get_TotalPower,
    Circuit_Disable,
    Circuit_Enable,
    Circuit_FirstPCElement,
    Circuit_FirstPDElement,
    Circuit_NextPCElement,
    Circuit_NextPDElement,
    Circuit_Get_AllBusNames,
    Circuit_Get_AllElementLosses,
    Circuit_Sample,
    Circuit_SaveSample,
    Circuit_SetActiveElement,
    Circuit_Capacity,
    Circuit_Get_AllBusVmagPu,
    Circuit_SetActiveBus,
    Circuit_SetActiveBusi,
    Circuit_Get_AllNodeNames,
    Circuit_Get_SystemY,
    Circuit_Get_AllBusDistances,
    Circuit_Get_AllNodeDistances,
    Circuit_Get_AllNodeDistancesByPhase,
    Circuit_Get_AllNodeVmagByPhase,
    Circuit_Get_AllNodeVmagPUByPhase,
    Circuit_Get_AllNodeNamesByPhase,
    Circuit_SetActiveClass,
    Circuit_FirstElement,
    Circuit_NextElement,
    Circuit_UpdateStorage,
    Circuit_Get_ParentPDElement,
    Circuit_EndOfTimeStepUpdate,
    Circuit_Get_YNodeOrder,
    Circuit_Get_YCurrents,
    Circuit_Get_YNodeVarray,
    CktElement_Get_BusNames,
    CktElement_Get_Name,
    CktElement_Get_NumConductors,
    CktElement_Get_NumPhases,
    CktElement_Get_NumTerminals,
    CktElement_Set_BusNames,
    CktElement_Get_Currents,
    CktElement_Get_Voltages,
    CktElement_Get_EmergAmps,
    CktElement_Get_Enabled,
    CktElement_Get_Losses,
    CktElement_Get_NormalAmps,
    CktElement_Get_PhaseLosses,
    CktElement_Get_Powers,
    CktElement_Get_SeqCurrents,
    CktElement_Get_SeqPowers,
    CktElement_Get_SeqVoltages,
    CktElement_Close,
    CktElement_Open,
    CktElement_Set_EmergAmps,
    CktElement_Set_Enabled,
    CktElement_Set_NormalAmps,
    CktElement_IsOpen,
    CktElement_Get_AllPropertyNames,
    CktElement_Get_NumProperties,
    CktElement_Get_Residuals,
    CktElement_Get_Yprim,
    CktElement_Get_DisplayName,
    CktElement_Get_GUID,
    CktElement_Get_Handle,
    CktElement_Set_DisplayName,
    CktElement_Get_Controller,
    CktElement_Get_EnergyMeter,
    CktElement_Get_HasVoltControl,
    CktElement_Get_HasSwitchControl,
    CktElement_Get_CplxSeqVoltages,
    CktElement_Get_CplxSeqCurrents,
    CktElement_Get_AllVariableNames,
    CktElement_Get_AllVariableValues,
    CktElement_Get_Variable,
    CktElement_Get_Variablei,
    CktElement_Get_NodeOrder,
    CktElement_Get_HasOCPDevice,
    CktElement_Get_NumControls,
    CktElement_Get_OCPDevIndex,
    CktElement_Get_OCPDevType,
    CktElement_Get_CurrentsMagAng,
    CktElement_Get_VoltagesMagAng,
    CmathLib_Get_cmplx,
    CmathLib_Get_cabs,
    CmathLib_Get_cdang,
    CmathLib_Get_ctopolardeg,
    CmathLib_Get_pdegtocomplex,
    CmathLib_Get_cmul,
    CmathLib_Get_cdiv,
    CtrlQueue_ClearQueue,
    CtrlQueue_Delete,
    CtrlQueue_Get_ActionCode,
    CtrlQueue_Get_DeviceHandle,
    CtrlQueue_Get_NumActions,
    CtrlQueue_Show,
    CtrlQueue_ClearActions,
    CtrlQueue_Get_PopAction,
    CtrlQueue_Set_Action,
    CtrlQueue_Get_QueueSize,
    CtrlQueue_DoAllQueue,
    CtrlQueue_Get_Queue,
    DSS_Get_NumCircuits,
    DSS_ClearAll,
    DSS_Get_Version,
    DSS_Start,
    DSS_Get_Classes,
    DSS_Get_UserClasses,
    DSS_Get_NumClasses,
    DSS_Get_NumUserClasses,
    DSS_Get_DataPath,
    DSS_Set_DataPath,
    DSS_Reset,
    DSS_Get_DefaultEditor,
    DSS_SetActiveClass,
    DSSElement_Get_AllPropertyNames,
    DSSElement_Get_Name,
    DSSElement_Get_NumProperties,
    DSSimComs_BusVoltagepu,
    DSSimComs_BusVoltage,
    { DSSMain_Get_ActiveCircuit, }
    { DSSMain_Get_NumCircuits, }
    { DSSMain_Set_ActiveCircuit, }
    { DSSProgress_Close, }
    { DSSProgress_Set_Caption, }
    { DSSProgress_Set_PctProgress, }
    { DSSProgress_Show, }
    { DSSProperty_Get_Description, }
    { DSSProperty_Get_Name, }
    { DSSProperty_Get_Val, }
    { DSSProperty_Set_Val, }
    DSS_Executive_Get_Command,
    DSS_Executive_Get_NumCommands,
    DSS_Executive_Get_NumOptions,
    DSS_Executive_Get_Option,
    DSS_Executive_Get_CommandHelp,
    DSS_Executive_Get_OptionHelp,
    DSS_Executive_Get_OptionValue,
    Error_Get_Description,
    Error_Get_Number,
    Fuses_Get_AllNames,
    Fuses_Get_Count,
    Fuses_Get_First,
    Fuses_Get_Name,
    Fuses_Get_Next,
    Fuses_Set_Name,
    Fuses_Get_MonitoredObj,
    Fuses_Get_MonitoredTerm,
    Fuses_Get_SwitchedObj,
    Fuses_Set_MonitoredObj,
    Fuses_Set_MonitoredTerm,
    Fuses_Set_SwitchedObj,
    Fuses_Get_SwitchedTerm,
    Fuses_Set_SwitchedTerm,
    Fuses_Get_TCCcurve,
    Fuses_Set_TCCcurve,
    Fuses_Get_RatedCurrent,
    Fuses_Set_RatedCurrent,
    Fuses_Get_Delay,
    Fuses_Open,
    Fuses_Close,
    Fuses_Set_Delay,
    Fuses_Get_idx,
    Fuses_Set_idx,
    Fuses_Get_NumPhases,
    Generators_Get_AllNames,
    Generators_Get_First,
    Generators_Get_Name,
    Generators_Get_Next,
    Generators_Get_RegisterNames,
    Generators_Get_RegisterValues,
    Generators_Get_ForcedON,
    Generators_Set_ForcedON,
    Generators_Set_Name,
    Generators_Get_kV,
    Generators_Get_kvar,
    Generators_Get_kW,
    Generators_Get_PF,
    Generators_Get_Phases,
    Generators_Set_kV,
    Generators_Set_kvar,
    Generators_Set_kW,
    Generators_Set_PF,
    Generators_Set_Phases,
    Generators_Get_Count,
    Generators_Get_idx,
    Generators_Set_idx,
    Generators_Get_Model,
    Generators_Set_Model,
    Generators_Get_kVArated,
    Generators_Set_kVArated,
    Generators_Get_Vmaxpu,
    Generators_Get_Vminpu,
    Generators_Set_Vmaxpu,
    Generators_Set_Vminpu,
    ISources_Get_AllNames,
    ISources_Get_Count,
    ISources_Get_First,
    ISources_Get_Next,
    ISources_Get_Name,
    ISources_Set_Name,
    ISources_Get_Amps,
    ISources_Set_Amps,
    ISources_Get_AngleDeg,
    ISources_Get_Frequency,
    ISources_Set_AngleDeg,
    ISources_Set_Frequency,
    LineCodes_Get_Count,
    LineCodes_Get_First,
    LineCodes_Get_Next,
    LineCodes_Get_Name,
    LineCodes_Set_Name,
    LineCodes_Get_IsZ1Z0,
    LineCodes_Get_Units,
    LineCodes_Set_Units,
    LineCodes_Get_Phases,
    LineCodes_Set_Phases,
    LineCodes_Get_R1,
    LineCodes_Set_R1,
    LineCodes_Get_X1,
    LineCodes_Set_X1,
    LineCodes_Get_R0,
    LineCodes_Get_X0,
    LineCodes_Set_R0,
    LineCodes_Set_X0,
    LineCodes_Get_C0,
    LineCodes_Get_C1,
    LineCodes_Set_C0,
    LineCodes_Set_C1,
    LineCodes_Get_Cmatrix,
    LineCodes_Get_Rmatrix,
    LineCodes_Get_Xmatrix,
    LineCodes_Set_Cmatrix,
    LineCodes_Set_Rmatrix,
    LineCodes_Set_Xmatrix,
    LineCodes_Get_NormAmps,
    LineCodes_Set_NormAmps,
    LineCodes_Get_EmergAmps,
    LineCodes_Set_EmergAmps,
    LineCodes_Get_AllNames,
    Lines_Get_AllNames,
    Lines_Get_Bus1,
    Lines_Get_Bus2,
    Lines_Get_First,
    Lines_Get_Length,
    Lines_Get_LineCode,
    Lines_Get_Name,
    Lines_Get_Next,
    Lines_Get_Phases,
    Lines_Get_R1,
    Lines_Get_X1,
    Lines_New,
    Lines_Set_Bus1,
    Lines_Set_Bus2,
    Lines_Set_Length,
    Lines_Set_LineCode,
    Lines_Set_Name,
    Lines_Set_Phases,
    Lines_Set_R1,
    Lines_Set_X1,
    Lines_Get_C0,
    Lines_Get_C1,
    Lines_Get_Cmatrix,
    Lines_Get_R0,
    Lines_Get_Rmatrix,
    Lines_Get_X0,
    Lines_Get_Xmatrix,
    Lines_Set_C0,
    Lines_Set_C1,
    Lines_Set_Cmatrix,
    Lines_Set_R0,
    Lines_Set_Rmatrix,
    Lines_Set_X0,
    Lines_Set_Xmatrix,
    Lines_Get_EmergAmps,
    Lines_Get_NormAmps,
    Lines_Set_EmergAmps,
    Lines_Set_NormAmps,
    Lines_Get_Geometry,
    Lines_Set_Geometry,
    Lines_Get_Rg,
    Lines_Get_Rho,
    Lines_Get_Xg,
    Lines_Set_Rg,
    Lines_Set_Rho,
    Lines_Set_Xg,
    Lines_Get_Yprim,
    Lines_Set_Yprim,
    Lines_Get_NumCust,
    Lines_Get_TotalCust,
    Lines_Get_Parent,
    Lines_Get_Count,
    Lines_Get_Spacing,
    Lines_Set_Spacing,
    Lines_Get_Units,
    Lines_Set_Units,
    Loads_Get_AllNames,
    Loads_Get_First,
    Loads_Get_idx,
    Loads_Get_Name,
    Loads_Get_Next,
    Loads_Set_idx,
    Loads_Set_Name,
    Loads_Get_kV,
    Loads_Get_kvar,
    Loads_Get_kW,
    Loads_Get_PF,
    Loads_Set_kV,
    Loads_Set_kvar,
    Loads_Set_kW,
    Loads_Set_PF,
    Loads_Get_Count,
    Loads_Get_AllocationFactor,
    Loads_Get_Cfactor,
    Loads_Get_Class_,
    Loads_Get_CVRcurve,
    Loads_Get_CVRvars,
    Loads_Get_CVRwatts,
    Loads_Get_daily,
    Loads_Get_duty,
    Loads_Get_Growth,
    Loads_Get_IsDelta,
    Loads_Get_kva,
    Loads_Get_kwh,
    Loads_Get_kwhdays,
    Loads_Get_Model,
    Loads_Get_NumCust,
    Loads_Get_PctMean,
    Loads_Get_PctStdDev,
    Loads_Get_Rneut,
    Loads_Get_Spectrum,
    Loads_Get_Status,
    Loads_Get_Vmaxpu,
    Loads_Get_Vminemerg,
    Loads_Get_Vminnorm,
    Loads_Get_Vminpu,
    Loads_Get_xfkVA,
    Loads_Get_Xneut,
    Loads_Get_Yearly,
    Loads_Set_AllocationFactor,
    Loads_Set_Cfactor,
    Loads_Set_Class_,
    Loads_Set_CVRcurve,
    Loads_Set_CVRvars,
    Loads_Set_CVRwatts,
    Loads_Set_daily,
    Loads_Set_duty,
    Loads_Set_Growth,
    Loads_Set_IsDelta,
    Loads_Set_kva,
    Loads_Set_kwh,
    Loads_Set_kwhdays,
    Loads_Set_Model,
    Loads_Set_NumCust,
    Loads_Set_PctMean,
    Loads_Set_PctStdDev,
    Loads_Set_Rneut,
    Loads_Set_Spectrum,
    Loads_Set_Status,
    Loads_Set_Vmaxpu,
    Loads_Set_Vminemerg,
    Loads_Set_Vminnorm,
    Loads_Set_Vminpu,
    Loads_Set_xfkVA,
    Loads_Set_Xneut,
    Loads_Set_Yearly,
    Loads_Get_ZIPV,
    Loads_Set_ZIPV,
    Loads_Get_pctSeriesRL,
    Loads_Set_pctSeriesRL,
    Loads_Get_RelWeight,
    LoadShapes_Get_Name,
    LoadShapes_Set_Name,
    LoadShapes_Get_Count,
    LoadShapes_Get_First,
    LoadShapes_Get_Next,
    LoadShapes_Get_AllNames,
    LoadShapes_Get_Npts,
    LoadShapes_Get_Pmult,
    LoadShapes_Get_Qmult,
    LoadShapes_Set_Npts,
    LoadShapes_Set_Pmult,
    LoadShapes_Set_Qmult,
    LoadShapes_Normalize,
    LoadShapes_Get_TimeArray,
    LoadShapes_Set_TimeArray,
    LoadShapes_Get_HrInterval,
    LoadShapes_Get_MinInterval,
    LoadShapes_Get_sInterval,
    LoadShapes_Set_HrInterval,
    LoadShapes_Set_MinInterval,
    LoadShapes_Set_Sinterval,
    LoadShapes_Get_PBase,
    LoadShapes_Get_Qbase,
    LoadShapes_Set_PBase,
    LoadShapes_Set_Qbase,
    LoadShapes_Get_UseActual,
    LoadShapes_Set_UseActual,
    Meters_Get_AllNames,
    Meters_Get_First,
    Meters_Get_Name,
    Meters_Get_Next,
    Meters_Get_RegisterNames,
    Meters_Get_RegisterValues,
    Meters_Reset,
    Meters_ResetAll,
    Meters_Sample,
    Meters_Save,
    Meters_Set_Name,
    Meters_Get_Totals,
    Meters_Get_Peakcurrent,
    Meters_Set_Peakcurrent,
    Meters_Get_CalcCurrent,
    Meters_Set_CalcCurrent,
    Meters_Get_AllocFactors,
    Meters_Set_AllocFactors,
    Meters_Get_MeteredElement,
    Meters_Get_MeteredTerminal,
    Meters_Set_MeteredElement,
    Meters_Set_MeteredTerminal,
    Meters_Get_DIFilesAreOpen,
    Meters_CloseAllDIFiles,
    Meters_OpenAllDIFiles,
    Meters_SampleAll,
    Meters_SaveAll,
    Meters_Get_AllEndElements,
    Meters_Get_CountEndElements,
    Meters_Get_Count,
    Meters_Get_AllBranchesInZone,
    Meters_Get_CountBranches,
    Meters_Get_SAIFI,
    Meters_Get_SequenceIndex,
    Meters_Set_SequenceIndex,
    Meters_Get_SAIFIKW,
    Meters_DoReliabilityCalc,
    Meters_Get_SeqListSize,
    Meters_Get_TotalCustomers,
    Meters_Get_SAIDI,
    Meters_Get_CustInterrupts,
    Meters_Get_NumSections,
    Meters_SetActiveSection,
    Meters_Get_AvgRepairTime,
    Meters_Get_FaultRateXRepairHrs,
    Meters_Get_NumSectionBranches,
    Meters_Get_NumSectionCustomers,
    Meters_Get_OCPDeviceType,
    Meters_Get_SumBranchFltRates,
    Meters_Get_SectSeqIdx,
    Meters_Get_SectTotalCust,
    Monitors_Get_AllNames,
    Monitors_Get_FileName,
    Monitors_Get_First,
    Monitors_Get_Mode,
    Monitors_Get_Name,
    Monitors_Get_Next,
    Monitors_Reset,
    Monitors_ResetAll,
    Monitors_Sample,
    Monitors_Save,
    Monitors_Set_Mode,
    Monitors_Show,
    Monitors_Set_Name,
    Monitors_Get_ByteStream,
    Monitors_Get_SampleCount,
    Monitors_SampleAll,
    Monitors_SaveAll,
    Monitors_Get_Count,
    Monitors_Process,
    Monitors_ProcessAll,
    Monitors_Get_Channel,
    Monitors_Get_dblFreq,
    Monitors_Get_dblHour,
    Monitors_Get_FileVersion,
    Monitors_Get_Header,
    Monitors_Get_NumChannels,
    Monitors_Get_RecordSize,
    Monitors_Get_Element,
    Monitors_Set_Element,
    Monitors_Get_Terminal,
    Monitors_Set_Terminal,
    Parser_Get_CmdString,
    Parser_Set_CmdString,
    Parser_Get_NextParam,
    Parser_Get_AutoIncrement,
    Parser_Set_AutoIncrement,
    Parser_Get_DblValue,
    Parser_Get_IntValue,
    Parser_Get_StrValue,
    Parser_Get_WhiteSpace,
    Parser_Set_WhiteSpace,
    Parser_Get_BeginQuote,
    Parser_Get_EndQuote,
    Parser_Set_BeginQuote,
    Parser_Set_EndQuote,
    Parser_Get_Delimiters,
    Parser_Set_Delimiters,
    Parser_ResetDelimiters,
    Parser_Get_Vector,
    Parser_Get_Matrix,
    Parser_Get_SymMatrix,
    PDElements_Get_Count,
    PDElements_Get_FaultRate,
    PDElements_Get_First,
    PDElements_Get_IsShunt,
    PDElements_Get_Next,
    PDElements_Get_pctPermanent,
    PDElements_Set_FaultRate,
    PDElements_Set_pctPermanent,
    PDElements_Get_Name,
    PDElements_Set_Name,
    PDElements_Get_AccumulatedL,
    PDElements_Get_Lambda,
    PDElements_Get_Numcustomers,
    PDElements_Get_ParentPDElement,
    PDElements_Get_RepairTime,
    PDElements_Get_Totalcustomers,
    PDElements_Get_FromTerminal,
    PDElements_Get_TotalMiles,
    PDElements_Get_SectionID,
    PDElements_Set_RepairTime,
    PVSystems_Get_AllNames,
    PVSystems_Get_RegisterNames,
    PVSystems_Get_RegisterValues,
    PVSystems_Get_First,
    PVSystems_Get_Next,
    PVSystems_Get_Count,
    PVSystems_Get_idx,
    PVSystems_Set_idx,
    PVSystems_Get_Name,
    PVSystems_Set_Name,
    PVSystems_Get_Irradiance,
    PVSystems_Set_Irradiance,
    PVSystems_Get_kvar,
    PVSystems_Get_kVArated,
    PVSystems_Get_kW,
    PVSystems_Get_PF,
    Reclosers_Get_AllNames,
    Reclosers_Get_Count,
    Reclosers_Get_First,
    Reclosers_Get_Name,
    Reclosers_Get_Next,
    Reclosers_Set_Name,
    Reclosers_Get_MonitoredTerm,
    Reclosers_Set_MonitoredTerm,
    Reclosers_Get_SwitchedObj,
    Reclosers_Set_SwitchedObj,
    Reclosers_Get_MonitoredObj,
    Reclosers_Get_SwitchedTerm,
    Reclosers_Set_MonitoredObj,
    Reclosers_Set_SwitchedTerm,
    Reclosers_Get_NumFast,
    Reclosers_Get_RecloseIntervals,
    Reclosers_Get_Shots,
    Reclosers_Set_NumFast,
    Reclosers_Set_Shots,
    Reclosers_Get_PhaseTrip,
    Reclosers_Set_PhaseTrip,
    Reclosers_Get_GroundInst,
    Reclosers_Get_GroundTrip,
    Reclosers_Get_PhaseInst,
    Reclosers_Set_GroundInst,
    Reclosers_Set_GroundTrip,
    Reclosers_Set_PhaseInst,
    Reclosers_Close,
    Reclosers_Open,
    Reclosers_Get_idx,
    Reclosers_Set_idx,
    RegControls_Get_AllNames,
    RegControls_Get_CTPrimary,
    RegControls_Get_Delay,
    RegControls_Get_First,
    RegControls_Get_ForwardBand,
    RegControls_Get_ForwardR,
    RegControls_Get_ForwardVreg,
    RegControls_Get_ForwardX,
    RegControls_Get_IsInverseTime,
    RegControls_Get_IsReversible,
    RegControls_Get_MaxTapChange,
    RegControls_Get_MonitoredBus,
    RegControls_Get_Name,
    RegControls_Get_Next,
    RegControls_Get_PTratio,
    RegControls_Get_ReverseBand,
    RegControls_Get_ReverseR,
    RegControls_Get_ReverseVreg,
    RegControls_Get_ReverseX,
    RegControls_Get_TapDelay,
    RegControls_Get_TapWinding,
    RegControls_Get_Transformer,
    RegControls_Get_VoltageLimit,
    RegControls_Get_Winding,
    RegControls_Get_TapNumber,
    RegControls_Set_CTPrimary,
    RegControls_Set_Delay,
    RegControls_Set_ForwardBand,
    RegControls_Set_ForwardR,
    RegControls_Set_ForwardVreg,
    RegControls_Set_ForwardX,
    RegControls_Set_IsInverseTime,
    RegControls_Set_IsReversible,
    RegControls_Set_MaxTapChange,
    RegControls_Set_MonitoredBus,
    RegControls_Set_Name,
    RegControls_Set_PTratio,
    RegControls_Set_ReverseBand,
    RegControls_Set_ReverseR,
    RegControls_Set_ReverseVreg,
    RegControls_Set_ReverseX,
    RegControls_Set_TapDelay,
    RegControls_Set_TapWinding,
    RegControls_Set_Transformer,
    RegControls_Set_VoltageLimit,
    RegControls_Set_Winding,
    RegControls_Set_TapNumber,
    RegControls_Get_Count,
    RegControls_Reset,
    Relays_Get_AllNames,
    Relays_Get_Count,
    Relays_Get_First,
    Relays_Get_Name,
    Relays_Get_Next,
    Relays_Set_Name,
    Relays_Get_MonitoredObj,
    Relays_Set_MonitoredObj,
    Relays_Get_MonitoredTerm,
    Relays_Get_SwitchedObj,
    Relays_Set_MonitoredTerm,
    Relays_Set_SwitchedObj,
    Relays_Get_SwitchedTerm,
    Relays_Set_SwitchedTerm,
    Relays_Get_idx,
    Relays_Set_idx,
    Sensors_Get_AllNames,
    Sensors_Get_Count,
    Sensors_Get_Currents,
    Sensors_Get_First,
    Sensors_Get_IsDelta,
    Sensors_Get_kVARS,
    Sensors_Get_kVS,
    Sensors_Get_kWS,
    Sensors_Get_MeteredElement,
    Sensors_Get_MeteredTerminal,
    Sensors_Get_Name,
    Sensors_Get_Next,
    Sensors_Get_PctError,
    Sensors_Get_ReverseDelta,
    Sensors_Get_Weight,
    Sensors_Reset,
    Sensors_ResetAll,
    Sensors_Set_Currents,
    Sensors_Set_IsDelta,
    Sensors_Set_kVARS,
    Sensors_Set_kVS,
    Sensors_Set_kWS,
    Sensors_Set_MeteredElement,
    Sensors_Set_MeteredTerminal,
    Sensors_Set_Name,
    Sensors_Set_PctError,
    Sensors_Set_ReverseDelta,
    Sensors_Set_Weight,
    Sensors_Get_kVbase,
    Sensors_Set_kVbase,
    Settings_Get_AllowDuplicates,
    Settings_Get_AutoBusList,
    Settings_Get_CktModel,
    Settings_Get_EmergVmaxpu,
    Settings_Get_EmergVminpu,
    Settings_Get_NormVmaxpu,
    Settings_Get_NormVminpu,
    Settings_Get_ZoneLock,
    Settings_Set_AllocationFactors,
    Settings_Set_AllowDuplicates,
    Settings_Set_AutoBusList,
    Settings_Set_CktModel,
    Settings_Set_EmergVmaxpu,
    Settings_Set_EmergVminpu,
    Settings_Set_NormVmaxpu,
    Settings_Set_NormVminpu,
    Settings_Set_ZoneLock,
    Settings_Get_LossRegs,
    Settings_Get_LossWeight,
    Settings_Get_Trapezoidal,
    Settings_Get_UEregs,
    Settings_Get_UEweight,
    Settings_Set_LossRegs,
    Settings_Set_LossWeight,
    Settings_Set_Trapezoidal,
    Settings_Set_UEregs,
    Settings_Set_UEweight,
    Settings_Get_ControlTrace,
    Settings_Get_VoltageBases,
    Settings_Set_ControlTrace,
    Settings_Set_VoltageBases,
    Settings_Get_PriceCurve,
    Settings_Get_PriceSignal,
    Settings_Set_PriceCurve,
    Settings_Set_PriceSignal,
    Solution_Get_Frequency,
    Solution_Get_Hour,
    Solution_Get_Iterations,
    Solution_Get_LoadMult,
    Solution_Get_MaxIterations,
    Solution_Get_Mode,
    Solution_Get_Number,
    Solution_Get_Random,
    Solution_Get_Seconds,
    Solution_Get_StepSize,
    Solution_Get_Tolerance,
    Solution_Get_Year,
    Solution_Set_Frequency,
    Solution_Set_Hour,
    Solution_Set_LoadMult,
    Solution_Set_MaxIterations,
    Solution_Set_Mode,
    Solution_Set_Number,
    Solution_Set_Random,
    Solution_Set_Seconds,
    Solution_Set_StepSize,
    Solution_Set_Tolerance,
    Solution_Set_Year,
    Solution_Solve,
    Solution_Get_ModeID,
    Solution_Get_LoadModel,
    Solution_Set_LoadModel,
    Solution_Get_LDCurve,
    Solution_Set_LDCurve,
    Solution_Get_pctGrowth,
    Solution_Set_pctGrowth,
    Solution_Get_AddType,
    Solution_Set_AddType,
    Solution_Get_GenkW,
    Solution_Set_GenkW,
    Solution_Get_GenPF,
    Solution_Set_GenPF,
    Solution_Get_Capkvar,
    Solution_Set_Capkvar,
    Solution_Get_Algorithm,
    Solution_Set_Algorithm,
    Solution_Get_ControlMode,
    Solution_Set_ControlMode,
    Solution_Get_GenMult,
    Solution_Set_GenMult,
    Solution_Get_DefaultDaily,
    Solution_Get_DefaultYearly,
    Solution_Set_DefaultDaily,
    Solution_Set_DefaultYearly,
    Solution_Get_EventLog,
    Solution_Get_dblHour,
    Solution_Set_dblHour,
    Solution_Set_StepsizeHr,
    Solution_Set_StepsizeMin,
    Solution_Get_ControlIterations,
    Solution_Get_MaxControlIterations,
    Solution_Sample_DoControlActions,
    Solution_Set_ControlIterations,
    Solution_Set_MaxControlIterations,
    Solution_CheckFaultStatus,
    Solution_SolveDirect,
    Solution_SolveNoControl,
    Solution_SolvePflow,
    Solution_SolvePlusControl,
    Solution_SolveSnap,
    Solution_CheckControls,
    Solution_InitSnap,
    Solution_Get_SystemYChanged,
    Solution_BuildYMatrix,
    Solution_DoControlActions,
    Solution_SampleControlDevices,
    Solution_Get_Converged,
    Solution_Set_Converged,
    Solution_Get_Totaliterations,
    Solution_Get_MostIterationsDone,
    Solution_Get_ControlActionsDone,
    Solution_Set_ControlActionsDone,
    Solution_Cleanup,
    Solution_FinishTimeStep,
    Solution_Get_Process_Time,
    Solution_Get_Total_Time,
    Solution_Set_Total_Time,
    Solution_Get_Time_of_Step,
    Solution_Get_IntervalHrs,
    Solution_Set_IntervalHrs,
    Solution_Get_MinIterations,
    Solution_Set_MinIterations,
    SwtControls_Get_Action,
    SwtControls_Get_AllNames,
    SwtControls_Get_Delay,
    SwtControls_Get_First,
    SwtControls_Get_IsLocked,
    SwtControls_Get_Name,
    SwtControls_Get_Next,
    SwtControls_Get_SwitchedObj,
    SwtControls_Get_SwitchedTerm,
    SwtControls_Set_Action,
    SwtControls_Set_Delay,
    SwtControls_Set_IsLocked,
    SwtControls_Set_Name,
    SwtControls_Set_SwitchedObj,
    SwtControls_Set_SwitchedTerm,
    SwtControls_Get_Count,
    SwtControls_Get_NormalState,
    SwtControls_Set_NormalState,
    SwtControls_Get_State,
    SwtControls_Set_State,
    SwtControls_Reset,
    Text_Get_Command,
    Text_Set_Command,
    Text_Get_Result,
    Topology_Get_NumLoops,
    Topology_Get_ActiveBranch,
    Topology_Get_AllIsolatedBranches,
    Topology_Get_AllLoopedPairs,
    Topology_Get_BackwardBranch,
    Topology_Get_BranchName,
    Topology_Get_First,
    Topology_Get_ForwardBranch,
    Topology_Get_LoopedBranch,
    Topology_Get_Next,
    Topology_Get_NumIsolatedBranches,
    Topology_Get_ParallelBranch,
    Topology_Set_BranchName,
    Topology_Get_AllIsolatedLoads,
    Topology_Get_FirstLoad,
    Topology_Get_NextLoad,
    Topology_Get_NumIsolatedLoads,
    Topology_Get_ActiveLevel,
    Topology_Get_BusName,
    Topology_Set_BusName,
    Transformers_Get_AllNames,
    Transformers_Get_First,
    Transformers_Get_IsDelta,
    Transformers_Get_kV,
    Transformers_Get_kVA,
    Transformers_Get_MaxTap,
    Transformers_Get_MinTap,
    Transformers_Get_Name,
    Transformers_Get_Next,
    Transformers_Get_NumTaps,
    Transformers_Get_NumWindings,
    Transformers_Get_R,
    Transformers_Get_Rneut,
    Transformers_Get_Tap,
    Transformers_Get_Wdg,
    Transformers_Get_XfmrCode,
    Transformers_Get_Xhl,
    Transformers_Get_Xht,
    Transformers_Get_Xlt,
    Transformers_Get_Xneut,
    Transformers_Set_IsDelta,
    Transformers_Set_kV,
    Transformers_Set_kVA,
    Transformers_Set_MaxTap,
    Transformers_Set_MinTap,
    Transformers_Set_Name,
    Transformers_Set_NumTaps,
    Transformers_Set_NumWindings,
    Transformers_Set_R,
    Transformers_Set_Rneut,
    Transformers_Set_Tap,
    Transformers_Set_Wdg,
    Transformers_Set_XfmrCode,
    Transformers_Set_Xhl,
    Transformers_Set_Xht,
    Transformers_Set_Xlt,
    Transformers_Set_Xneut,
    Transformers_Get_Count,
    Vsources_Get_AllNames,
    Vsources_Get_Count,
    Vsources_Get_First,
    Vsources_Get_Next,
    Vsources_Get_Name,
    Vsources_Set_Name,
    Vsources_Get_BasekV,
    Vsources_Get_pu,
    Vsources_Set_BasekV,
    Vsources_Set_pu,
    Vsources_Get_AngleDeg,
    Vsources_Get_Frequency,
    Vsources_Get_Phases,
    Vsources_Set_AngleDeg,
    Vsources_Set_Frequency,
    Vsources_Set_Phases,
    XYCurves_Get_Count,
    XYCurves_Get_First,
    XYCurves_Get_Name,
    XYCurves_Get_Next,
    XYCurves_Set_Name,
    XYCurves_Get_Npts,
    XYCurves_Get_Xarray,
    XYCurves_Set_Npts,
    XYCurves_Set_Xarray,
    XYCurves_Get_x,
    XYCurves_Get_y,
    XYCurves_Get_Yarray,
    XYCurves_Set_x,
    XYCurves_Set_y,
    XYCurves_Get_Xscale,
    XYCurves_Get_Xshift,
    XYCurves_Get_Yscale,
    XYCurves_Get_Yshift,
    XYCurves_Set_Xscale,
    XYCurves_Set_Xshift,
    XYCurves_Set_Yscale,
    XYCurves_Set_Yshift,
    
    YMatrix_GetCompressedYMatrix,
    YMatrix_ZeroInjCurr,
    YMatrix_GetSourceInjCurrents,
    YMatrix_GetPCInjCurr,
    YMatrix_BuildYMatrixD,
    YMatrix_AddInAuxCurrents,
    YMatrix_getIpointer,
    YMatrix_getVpointer,
    YMatrix_SolveSystem,
    YMatrix_Set_SystemYChanged,
    YMatrix_Get_SystemYChanged,
    YMatrix_Set_UseAuxCurrents,
    YMatrix_Get_UseAuxCurrents;

begin
  IsDLL := TRUE;
  DSSExecutive := TExecutive.Create;
  DSSExecutive.CreateDefaultDSSItems;
end.
