unit CAPI_Relays;

interface

uses
    CAPI_Utils,
    CAPI_Types;

procedure Relays_Get_AllNames(var ResultPtr: PPAnsiChar; ResultCount: PAPISize); CDECL;
procedure Relays_Get_AllNames_GR(); CDECL;
function Relays_Get_Count(): Integer; CDECL;
function Relays_Get_First(): Integer; CDECL;
function Relays_Get_Name(): PAnsiChar; CDECL;
function Relays_Get_Next(): Integer; CDECL;
procedure Relays_Set_Name(const Value: PAnsiChar); CDECL;
function Relays_Get_MonitoredObj(): PAnsiChar; CDECL;
procedure Relays_Set_MonitoredObj(const Value: PAnsiChar); CDECL;
function Relays_Get_MonitoredTerm(): Integer; CDECL;
function Relays_Get_SwitchedObj(): PAnsiChar; CDECL;
procedure Relays_Set_MonitoredTerm(Value: Integer); CDECL;
procedure Relays_Set_SwitchedObj(const Value: PAnsiChar); CDECL;
function Relays_Get_SwitchedTerm(): Integer; CDECL;
procedure Relays_Set_SwitchedTerm(Value: Integer); CDECL;
function Relays_Get_idx(): Integer; CDECL;
procedure Relays_Set_idx(Value: Integer); CDECL;
procedure Relays_Close(); CDECL;
procedure Relays_Open(); CDECL;
procedure Relays_Reset(); CDECL;
function Relays_Get_NormalState(): Integer; CDECL;
procedure Relays_Set_NormalState(Value: Integer); CDECL;
function Relays_Get_State(): Integer; CDECL;
procedure Relays_Set_State(Value: Integer); CDECL;

implementation

uses
    CAPI_Constants,
    ControlElem,
    Executive,
    Relay,
    Circuit,
    DSSGlobals,
    Sysutils,
    DSSPointerList,
    DSSClass,
    DSSHelper;

//------------------------------------------------------------------------------
function _activeObj(DSS: TDSSContext; out obj: TRelayObj): Boolean; inline;
begin
    Result := False;
    obj := NIL;
    if InvalidCircuit(DSS) then
        Exit;
    
    obj := DSS.ActiveCircuit.Relays.Active;
    if obj = NIL then
    begin
        if DSS_CAPI_EXT_ERRORS then
        begin
            DoSimpleMsg(DSS, 'No active Relay object found! Activate one and retry.', 8989);
        end;
        Exit;
    end;
    
    Result := True;
end;
//------------------------------------------------------------------------------
procedure Set_Parameter(DSS: TDSSContext; const parm: String; const val: String);
var
    cmd: String;
    elem: TRelayObj;
begin
    if not _activeObj(DSS, elem) then
        Exit;
    DSS.SolutionAbort := FALSE;  // Reset for commands entered from outside
    cmd := Format('Relay.%s.%s=%s', [elem.Name, parm, val]);
    DSS.DSSExecutive.Command := cmd;
end;
//------------------------------------------------------------------------------
procedure Relays_Get_AllNames(var ResultPtr: PPAnsiChar; ResultCount: PAPISize); CDECL;
begin
    DefaultResult(ResultPtr, ResultCount);
    if InvalidCircuit(DSSPrime) then
        Exit;
    Generic_Get_AllNames(ResultPtr, ResultCount, DSSPrime.ActiveCircuit.Relays, False);
end;

procedure Relays_Get_AllNames_GR(); CDECL;
// Same as Relays_Get_AllNames but uses global result (GR) pointers
begin
    Relays_Get_AllNames(DSSPrime.GR_DataPtr_PPAnsiChar, @DSSPrime.GR_Counts_PPAnsiChar[0])
end;

//------------------------------------------------------------------------------
function Relays_Get_Count(): Integer; CDECL;
begin
    Result := 0;
    if InvalidCircuit(DSSPrime) then
        Exit;
    Result := DSSPrime.ActiveCircuit.Relays.Count;
end;
//------------------------------------------------------------------------------
function Relays_Get_First(): Integer; CDECL;
begin
    Result := 0;
    if InvalidCircuit(DSSPrime) then
        Exit;
    Result := Generic_CktElement_Get_First(DSSPrime, DSSPrime.ActiveCircuit.Relays);
end;
//------------------------------------------------------------------------------
function Relays_Get_Next(): Integer; CDECL;
begin
    Result := 0;
    if InvalidCircuit(DSSPrime) then
        Exit;
    Result := Generic_CktElement_Get_Next(DSSPrime, DSSPrime.ActiveCircuit.Relays);
end;
//------------------------------------------------------------------------------
function Relays_Get_Name(): PAnsiChar; CDECL;
var
    elem: TRelayObj;
begin
    Result := NIL;
    if not _activeObj(DSSPrime, elem) then
        Exit;
    Result := DSS_GetAsPAnsiChar(DSSPrime, elem.Name);
end;
//------------------------------------------------------------------------------
procedure Relays_Set_Name(const Value: PAnsiChar); CDECL;
// Set element active by name

begin
    if InvalidCircuit(DSSPrime) then
        Exit;
    if DSSPrime.RelayClass.SetActive(Value) then
    begin
        DSSPrime.ActiveCircuit.ActiveCktElement := DSSPrime.RelayClass.ElementList.Active;
        DSSPrime.ActiveCircuit.Relays.Get(DSSPrime.RelayClass.Active);
    end
    else
    begin
        DoSimpleMsg(DSSPrime, 'Relay "' + Value + '" Not Found in Active Circuit.', 77003);
    end;
end;
//------------------------------------------------------------------------------
function Relays_Get_MonitoredObj(): PAnsiChar; CDECL;
var
    elem: TRelayObj;
begin
    Result := NIL;
    if not _activeObj(DSSPrime, elem) then
        Exit;
    Result := DSS_GetAsPAnsiChar(DSSPrime, elem.MonitoredElementName);
end;

//------------------------------------------------------------------------------
procedure Relays_Set_MonitoredObj(const Value: PAnsiChar); CDECL;
begin
    Set_Parameter(DSSPrime, 'monitoredObj', Value);
end;
//------------------------------------------------------------------------------
function Relays_Get_MonitoredTerm(): Integer; CDECL;
var
    elem: TRelayObj;
begin
    Result := 0;
    if not _activeObj(DSSPrime, elem) then
        Exit;
    Result := elem.MonitoredElementTerminal;
end;
//------------------------------------------------------------------------------
function Relays_Get_SwitchedObj(): PAnsiChar; CDECL;
var
    elem: TRelayObj;
begin
    Result := NIL;
    if not _activeObj(DSSPrime, elem) then
        Exit;
    Result := DSS_GetAsPAnsiChar(DSSPrime, elem.ElementName);
end;

//------------------------------------------------------------------------------
procedure Relays_Set_MonitoredTerm(Value: Integer); CDECL;
begin
    Set_Parameter(DSSPrime, 'monitoredterm', IntToStr(Value));
end;
//------------------------------------------------------------------------------
procedure Relays_Set_SwitchedObj(const Value: PAnsiChar); CDECL;
begin
    Set_Parameter(DSSPrime, 'SwitchedObj', Value);
end;
//------------------------------------------------------------------------------
function Relays_Get_SwitchedTerm(): Integer; CDECL;
var
    elem: TRelayObj;
begin
    Result := 0;
    if not _activeObj(DSSPrime, elem) then
        Exit;
    Result := elem.ElementTerminal;
end;
//------------------------------------------------------------------------------
procedure Relays_Set_SwitchedTerm(Value: Integer); CDECL;
begin
    Set_Parameter(DSSPrime, 'SwitchedTerm', IntToStr(Value));
end;
//------------------------------------------------------------------------------
function Relays_Get_idx(): Integer; CDECL;
begin
    Result := 0;
    if InvalidCircuit(DSSPrime) then
        Exit;
    Result := DSSPrime.ActiveCircuit.Relays.ActiveIndex
end;
//------------------------------------------------------------------------------
procedure Relays_Set_idx(Value: Integer); CDECL;
var
    pRelay: TRelayObj;
begin
    if InvalidCircuit(DSSPrime) then
        Exit;
    pRelay := DSSPrime.ActiveCircuit.Relays.Get(Value);
    if pRelay = NIL then
    begin
        DoSimpleMsg(DSSPrime, 'Invalid Relay index: "' + IntToStr(Value) + '".', 656565);
    end;
    DSSPrime.ActiveCircuit.ActiveCktElement := pRelay;
end;
//------------------------------------------------------------------------------
procedure Relays_Close(); CDECL;
var
    elem: TRelayObj;
begin
    if not _activeObj(DSSPrime, elem) then
        Exit;
    elem.PresentState := CTRL_CLOSE;
end;
//------------------------------------------------------------------------------
procedure Relays_Open(); CDECL;
var
    elem: TRelayObj;
begin
    if not _activeObj(DSSPrime, elem) then
        Exit;
    elem.PresentState := CTRL_OPEN;
end;
//------------------------------------------------------------------------------
procedure Relays_Reset(); CDECL;
var
    elem: TRelayObj;
begin
    if not _activeObj(DSSPrime, elem) then
        Exit;
    elem.Reset();
end;
//------------------------------------------------------------------------------
function Relays_Get_NormalState(): Integer; CDECL;
var
    elem: TRelayObj;
begin
    Result := 0;
    if not _activeObj(DSSPrime, elem) then
        Exit;
    Result := Ord(elem.NormalState);
end;
//------------------------------------------------------------------------------
procedure Relays_Set_NormalState(Value: Integer); CDECL;
var
    elem: TRelayObj;
begin
    if not _activeObj(DSSPrime, elem) then
        Exit;
    if Value = dssActionOpen then
        elem.NormalState := CTRL_OPEN
    else if Value = dssActionClose then
        elem.NormalState := CTRL_CLOSE
    else
    begin
        DoSimpleMsg(DSSPrime, 'Invalid Relay normal state: "' + IntToStr(Value) + '".', 656569);
    end;
end;
//------------------------------------------------------------------------------
function Relays_Get_State(): Integer; CDECL;
var
    elem: TRelayObj;
begin
    Result := 0;
    if not _activeObj(DSSPrime, elem) then
        Exit;
    Result := Ord(elem.PresentState);
end;
//------------------------------------------------------------------------------
procedure Relays_Set_State(Value: Integer); CDECL;
var
    elem: TRelayObj;
begin
    if not _activeObj(DSSPrime, elem) then
        Exit;
    if Value = dssActionOpen then
        elem.PresentState := CTRL_OPEN
    else if Value = dssActionClose then
        elem.PresentState := CTRL_CLOSE
    else
    begin
        DoSimpleMsg(DSSPrime, 'Invalid Relay state: "' + IntToStr(Value) + '".', 656568);
    end;
end;
//------------------------------------------------------------------------------
end.
