unit CAPI_LoadShapes;

{$inline on}

interface

uses
    CAPI_Utils;

function LoadShapes_Get_Name(): PAnsiChar; CDECL;
procedure LoadShapes_Set_Name(const Value: PAnsiChar); CDECL;
function LoadShapes_Get_Count(): Integer; CDECL;
function LoadShapes_Get_First(): Integer; CDECL;
function LoadShapes_Get_Next(): Integer; CDECL;
procedure LoadShapes_Get_AllNames(var ResultPtr: PPAnsiChar; ResultCount: PInteger); CDECL;
procedure LoadShapes_Get_AllNames_GR(); CDECL;
function LoadShapes_Get_Npts(): Integer; CDECL;
procedure LoadShapes_Get_Pmult(var ResultPtr: PDouble; ResultCount: PInteger); CDECL;
procedure LoadShapes_Get_Pmult_GR(); CDECL;
procedure LoadShapes_Get_Qmult(var ResultPtr: PDouble; ResultCount: PInteger); CDECL;
procedure LoadShapes_Get_Qmult_GR(); CDECL;
procedure LoadShapes_Set_Npts(Value: Integer); CDECL;
procedure LoadShapes_Set_Pmult(ValuePtr: PDouble; ValueCount: Integer); CDECL;
procedure LoadShapes_Set_Qmult(ValuePtr: PDouble; ValueCount: Integer); CDECL;
procedure LoadShapes_Normalize(); CDECL;
procedure LoadShapes_Get_TimeArray(var ResultPtr: PDouble; ResultCount: PInteger); CDECL;
procedure LoadShapes_Get_TimeArray_GR(); CDECL;
procedure LoadShapes_Set_TimeArray(ValuePtr: PDouble; ValueCount: Integer); CDECL;
function LoadShapes_Get_HrInterval(): Double; CDECL;
function LoadShapes_Get_MinInterval(): Double; CDECL;
function LoadShapes_Get_sInterval(): Double; CDECL;
procedure LoadShapes_Set_HrInterval(Value: Double); CDECL;
procedure LoadShapes_Set_MinInterval(Value: Double); CDECL;
procedure LoadShapes_Set_Sinterval(Value: Double); CDECL;
function LoadShapes_New(const Name: PAnsiChar): Integer; CDECL;
function LoadShapes_Get_PBase(): Double; CDECL;
function LoadShapes_Get_Qbase(): Double; CDECL;
procedure LoadShapes_Set_PBase(Value: Double); CDECL;
procedure LoadShapes_Set_Qbase(Value: Double); CDECL;
function LoadShapes_Get_UseActual(): Wordbool; CDECL;
procedure LoadShapes_Set_UseActual(Value: Wordbool); CDECL;

implementation

uses
    CAPI_Constants,
    Loadshape,
    DSSGlobals,
    PointerList,
    ExecHelper;

var
    ActiveLSObject: TLoadshapeObj;

function LoadShapes_Get_Name_AnsiString(): Ansistring; inline;
var
    elem: TLoadshapeObj;
begin
    Result := '';
    elem := LoadShapeClass[ActiveActor].GetActiveObj;
    if elem <> NIL then
        Result := elem.Name;

end;

function LoadShapes_Get_Name(): PAnsiChar; CDECL;
begin
    Result := DSS_GetAsPAnsiChar(LoadShapes_Get_Name_AnsiString());
end;
//------------------------------------------------------------------------------
procedure LoadShapes_Set_Name(const Value: PAnsiChar); CDECL;
// Set element active by name

begin
    if ActiveCircuit[ActiveActor] <> NIL then
    begin
        if LoadShapeClass[ActiveActor].SetActive(Value) then
        begin
            ActiveLSObject := LoadShapeClass[ActiveActor].ElementList.Active;
            ActiveDSSObject[ActiveActor] := ActiveLSObject;
        end
        else
        begin
            DoSimpleMsg('Relay "' + Value + '" Not Found in Active Circuit.', 77003);
        end;
    end;

end;
//------------------------------------------------------------------------------
function LoadShapes_Get_Count(): Integer; CDECL;
begin
    Result := 0;
    if ActiveCircuit[ActiveActor] <> NIL then
        Result := LoadShapeClass[ActiveActor].ElementList.ListSize;
end;
//------------------------------------------------------------------------------
function LoadShapes_Get_First(): Integer; CDECL;
var
    iElem: Integer;
begin
    Result := 0;
    if ActiveCircuit[ActiveActor] <> NIL then
    begin
        iElem := LoadShapeClass[ActiveActor].First;
        if iElem <> 0 then
        begin
            ActiveLSObject := ActiveDSSObject[ActiveActor] as TLoadShapeObj;
            Result := 1;
        end
    end;
end;
//------------------------------------------------------------------------------
function LoadShapes_Get_Next(): Integer; CDECL;
var
    iElem: Integer;
begin
    Result := 0;
    if ActiveCircuit[ActiveActor] <> NIL then
    begin
        iElem := LoadShapeClass[ActiveActor].Next;
        if iElem <> 0 then
        begin
            ActiveLSObject := ActiveDSSObject[ActiveActor] as TLoadShapeObj;
            Result := iElem;
        end
    end;
end;
//------------------------------------------------------------------------------
procedure LoadShapes_Get_AllNames(var ResultPtr: PPAnsiChar; ResultCount: PInteger); CDECL;
var
    Result: PPAnsiCharArray;
    elem: TLoadshapeObj;
    pList: TPointerList;
    k: Integer;

begin
    Result := DSS_RecreateArray_PPAnsiChar(ResultPtr, ResultCount, (0) + 1);
    Result[0] := DSS_CopyStringAsPChar('NONE');
    if ActiveCircuit[ActiveActor] <> NIL then
    begin
        if LoadShapeClass[ActiveActor].ElementList.ListSize > 0 then
        begin
            pList := LoadShapeClass[ActiveActor].ElementList;
            DSS_RecreateArray_PPAnsiChar(Result, ResultPtr, ResultCount, (pList.ListSize - 1) + 1);
            k := 0;
            elem := pList.First;
            while elem <> NIL do
            begin
                Result[k] := DSS_CopyStringAsPChar(elem.Name);
                Inc(k);
                elem := pList.next;
            end;
        end;
    end;

end;

procedure LoadShapes_Get_AllNames_GR(); CDECL;
// Same as LoadShapes_Get_AllNames but uses global result (GR) pointers
begin
    LoadShapes_Get_AllNames(GR_DataPtr_PPAnsiChar, GR_CountPtr_PPAnsiChar)
end;

//------------------------------------------------------------------------------
function LoadShapes_Get_Npts(): Integer; CDECL;
begin
    Result := 0;
    if ActiveCircuit[ActiveActor] <> NIL then
        if ActiveLSObject <> NIL then
            Result := ActiveLSObject.NumPoints;
end;
//------------------------------------------------------------------------------
procedure LoadShapes_Get_Pmult(var ResultPtr: PDouble; ResultCount: PInteger); CDECL;
var
    Result: PDoubleArray;
    k: Integer;

begin
    Result := DSS_RecreateArray_PDouble(ResultPtr, ResultCount, (0) + 1);
    Result[0] := 0.0;  // error condition: one element array=0
    if ActiveCircuit[ActiveActor] <> NIL then
    begin
        if ActiveLSObject <> NIL then
        begin
            DSS_RecreateArray_PDouble(Result, ResultPtr, ResultCount, (ActiveLSObject.NumPoints - 1) + 1);
            for k := 0 to ActiveLSObject.NumPoints - 1 do
                Result[k] := ActiveLSObject.PMultipliers^[k + 1];
        end
        else
        begin
            DoSimpleMsg('No active Loadshape Object found.', 61001);
        end;
    end;
end;

procedure LoadShapes_Get_Pmult_GR(); CDECL;
// Same as LoadShapes_Get_Pmult but uses global result (GR) pointers
begin
    LoadShapes_Get_Pmult(GR_DataPtr_PDouble, GR_CountPtr_PDouble)
end;

//------------------------------------------------------------------------------
procedure LoadShapes_Get_Qmult(var ResultPtr: PDouble; ResultCount: PInteger); CDECL;
var
    Result: PDoubleArray;
    k: Integer;

begin
    Result := DSS_RecreateArray_PDouble(ResultPtr, ResultCount, (0) + 1);
    Result[0] := 0.0;  // error condition: one element array=0
    if ActiveCircuit[ActiveActor] <> NIL then
    begin
        if ActiveLSObject <> NIL then
        begin
            if assigned(ActiveLSObject.QMultipliers) then
            begin
                DSS_RecreateArray_PDouble(Result, ResultPtr, ResultCount, (ActiveLSObject.NumPoints - 1) + 1);
                for k := 0 to ActiveLSObject.NumPoints - 1 do
                    Result[k] := ActiveLSObject.QMultipliers^[k + 1];
            end;
        end
        else
        begin
            DoSimpleMsg('No active Loadshape Object found.', 61001);
        end;
    end;
end;

procedure LoadShapes_Get_Qmult_GR(); CDECL;
// Same as LoadShapes_Get_Qmult but uses global result (GR) pointers
begin
    LoadShapes_Get_Qmult(GR_DataPtr_PDouble, GR_CountPtr_PDouble)
end;

//------------------------------------------------------------------------------
procedure LoadShapes_Set_Npts(Value: Integer); CDECL;
begin
    if ActiveCircuit[ActiveActor] <> NIL then
        if ActiveLSObject <> NIL then
            ActiveLSObject.NumPoints := Value;
end;
//------------------------------------------------------------------------------
procedure LoadShapes_Set_Pmult(ValuePtr: PDouble; ValueCount: Integer); CDECL;
var
    Value: PDoubleArray;
    i, k, LoopLimit: Integer;

begin
    Value := PDoubleArray(ValuePtr);
    if ActiveCircuit[ActiveActor] <> NIL then
    begin
        if ActiveLSObject <> NIL then
            with ActiveLSObject do
            begin

        // Only put in as many points as we have allocated
                LoopLimit := (ValueCount - 1);
                if (LoopLimit - (0) + 1) > NumPoints then
                    LoopLimit := (0) + NumPoints - 1;

                ReallocMem(PMultipliers, Sizeof(PMultipliers^[1]) * NumPoints);
                k := 1;
                for i := (0) to LoopLimit do
                begin
                    ActiveLSObject.Pmultipliers^[k] := Value[i];
                    inc(k);
                end;

            end
        else
        begin
            DoSimpleMsg('No active Loadshape Object found.', 61002);
        end;
    end;
end;
//------------------------------------------------------------------------------
procedure LoadShapes_Set_Qmult(ValuePtr: PDouble; ValueCount: Integer); CDECL;
var
    Value: PDoubleArray;
    i, k, LoopLimit: Integer;

begin
    Value := PDoubleArray(ValuePtr);
    if ActiveCircuit[ActiveActor] <> NIL then
    begin
        if ActiveLSObject <> NIL then
            with ActiveLSObject do
            begin

        // Only put in as many points as we have allocated
                LoopLimit := (ValueCount - 1);
                if (LoopLimit - (0) + 1) > NumPoints then
                    LoopLimit := (0) + NumPoints - 1;

                ReallocMem(QMultipliers, Sizeof(QMultipliers^[1]) * NumPoints);
                k := 1;
                for i := (0) to LoopLimit do
                begin
                    ActiveLSObject.Qmultipliers^[k] := Value[i];
                    inc(k);
                end;

            end
        else
        begin
            DoSimpleMsg('No active Loadshape Object found.', 61002);
        end;
    end;
end;
//------------------------------------------------------------------------------
procedure LoadShapes_Normalize(); CDECL;
begin

    if ActiveCircuit[ActiveActor] <> NIL then
        if ActiveLSObject <> NIL then
            ActiveLSObject.Normalize;
end;
//------------------------------------------------------------------------------
procedure LoadShapes_Get_TimeArray(var ResultPtr: PDouble; ResultCount: PInteger); CDECL;
var
    Result: PDoubleArray;
    k: Integer;

begin
    Result := DSS_RecreateArray_PDouble(ResultPtr, ResultCount, (0) + 1);
    Result[0] := 0.0;  // error condition: one element array=0
    if ActiveCircuit[ActiveActor] <> NIL then
    begin
        if ActiveLSObject <> NIL then
        begin
            if ActiveLSObject.hours <> NIL then
            begin
                DSS_RecreateArray_PDouble(Result, ResultPtr, ResultCount, (ActiveLSObject.NumPoints - 1) + 1);
                for k := 0 to ActiveLSObject.NumPoints - 1 do
                    Result[k] := ActiveLSObject.Hours^[k + 1];
            end
        end
        else
        begin
            DoSimpleMsg('No active Loadshape Object found.', 61001);
        end;
    end;
end;

procedure LoadShapes_Get_TimeArray_GR(); CDECL;
// Same as LoadShapes_Get_TimeArray but uses global result (GR) pointers
begin
    LoadShapes_Get_TimeArray(GR_DataPtr_PDouble, GR_CountPtr_PDouble)
end;

//------------------------------------------------------------------------------
procedure LoadShapes_Set_TimeArray(ValuePtr: PDouble; ValueCount: Integer); CDECL;
var
    Value: PDoubleArray;
    i, k, LoopLimit: Integer;

begin
    Value := PDoubleArray(ValuePtr);
    if ActiveCircuit[ActiveActor] <> NIL then
    begin
        if ActiveLSObject <> NIL then
            with ActiveLSObject do
            begin

        // Only put in as many points as we have allocated
                LoopLimit := (ValueCount - 1);
                if (LoopLimit - (0) + 1) > NumPoints then
                    LoopLimit := (0) + NumPoints - 1;

                ReallocMem(Hours, Sizeof(Hours^[1]) * NumPoints);
                k := 1;
                for i := (0) to LoopLimit do
                begin
                    ActiveLSObject.Hours^[k] := Value[i];
                    inc(k);
                end;

            end
        else
        begin
            DoSimpleMsg('No active Loadshape Object found.', 61002);
        end;
    end;

end;
//------------------------------------------------------------------------------
function LoadShapes_Get_HrInterval(): Double; CDECL;
begin
    Result := 0.0;
    if ActiveCircuit[ActiveActor] <> NIL then
        if ActiveLSObject <> NIL then
            Result := ActiveLSObject.Interval;

end;
//------------------------------------------------------------------------------
function LoadShapes_Get_MinInterval(): Double; CDECL;
begin
    Result := 0.0;
    if ActiveCircuit[ActiveActor] <> NIL then
        if ActiveLSObject <> NIL then
            Result := ActiveLSObject.Interval * 60.0;
end;
//------------------------------------------------------------------------------
function LoadShapes_Get_sInterval(): Double; CDECL;
begin
    Result := 0.0;
    if ActiveCircuit[ActiveActor] <> NIL then
        if ActiveLSObject <> NIL then
            Result := ActiveLSObject.Interval * 3600.0;
end;
//------------------------------------------------------------------------------
procedure LoadShapes_Set_HrInterval(Value: Double); CDECL;
begin
    if ActiveCircuit[ActiveActor] <> NIL then
        if ActiveLSObject <> NIL then
            ActiveLSObject.Interval := Value;
end;
//------------------------------------------------------------------------------
procedure LoadShapes_Set_MinInterval(Value: Double); CDECL;
begin
    if ActiveCircuit[ActiveActor] <> NIL then
        if ActiveLSObject <> NIL then
            ActiveLSObject.Interval := Value / 60.0;
end;
//------------------------------------------------------------------------------
procedure LoadShapes_Set_Sinterval(Value: Double); CDECL;
begin
    if ActiveCircuit[ActiveActor] <> NIL then
        if ActiveLSObject <> NIL then
            ActiveLSObject.Interval := Value / 3600.0;
end;
//------------------------------------------------------------------------------
function LoadShapes_New(const Name: PAnsiChar): Integer; CDECL;
begin
    Result := AddObject('loadshape', Name);    // Returns handle to object
    ActiveLSObject := ActiveDSSObject[ActiveActor] as TLoadShapeObj;
end;
//------------------------------------------------------------------------------
function LoadShapes_Get_PBase(): Double; CDECL;
begin
    Result := 0.0;
    if ActiveCircuit[ActiveActor] <> NIL then
        if ActiveLSObject <> NIL then
            Result := ActiveLSObject.baseP;
end;
//------------------------------------------------------------------------------
function LoadShapes_Get_Qbase(): Double; CDECL;
begin
    Result := 0.0;
    if ActiveCircuit[ActiveActor] <> NIL then
        if ActiveLSObject <> NIL then
            Result := ActiveLSObject.baseQ;
end;
//------------------------------------------------------------------------------
procedure LoadShapes_Set_PBase(Value: Double); CDECL;
begin
    if ActiveCircuit[ActiveActor] <> NIL then
        if ActiveLSObject <> NIL then
            ActiveLSObject.baseP := Value;
end;
//------------------------------------------------------------------------------
procedure LoadShapes_Set_Qbase(Value: Double); CDECL;
begin
    if ActiveCircuit[ActiveActor] <> NIL then
        if ActiveLSObject <> NIL then
            ActiveLSObject.baseQ := Value;
end;
//------------------------------------------------------------------------------
function LoadShapes_Get_UseActual(): Wordbool; CDECL;
begin
    Result := FALSE;
    if ActiveCircuit[ActiveActor] <> NIL then
        if ActiveLSObject <> NIL then
            Result := ActiveLSObject.UseActual;
end;
//------------------------------------------------------------------------------
procedure LoadShapes_Set_UseActual(Value: Wordbool); CDECL;
begin
    if ActiveCircuit[ActiveActor] <> NIL then
        if ActiveLSObject <> NIL then
            ActiveLSObject.UseActual := Value;
end;
//------------------------------------------------------------------------------
end.
