unit CAPI_Generators;

{$inline on}

interface

uses
    CAPI_Utils;

procedure Generators_Get_AllNames(var ResultPtr: PPAnsiChar; ResultCount: PInteger); CDECL;
procedure Generators_Get_AllNames_GR(); CDECL;
function Generators_Get_First(): Integer; CDECL;
function Generators_Get_Name(): PAnsiChar; CDECL;
function Generators_Get_Next(): Integer; CDECL;
procedure Generators_Get_RegisterNames(var ResultPtr: PPAnsiChar; ResultCount: PInteger); CDECL;
procedure Generators_Get_RegisterNames_GR(); CDECL;
procedure Generators_Get_RegisterValues(var ResultPtr: PDouble; ResultCount: PInteger); CDECL;
procedure Generators_Get_RegisterValues_GR(); CDECL;
function Generators_Get_ForcedON(): Wordbool; CDECL;
procedure Generators_Set_ForcedON(Value: Wordbool); CDECL;
procedure Generators_Set_Name(const Value: PAnsiChar); CDECL;
function Generators_Get_kV(): Double; CDECL;
function Generators_Get_kvar(): Double; CDECL;
function Generators_Get_kW(): Double; CDECL;
function Generators_Get_PF(): Double; CDECL;
function Generators_Get_Phases(): Integer; CDECL;
procedure Generators_Set_kV(Value: Double); CDECL;
procedure Generators_Set_kvar(Value: Double); CDECL;
procedure Generators_Set_kW(Value: Double); CDECL;
procedure Generators_Set_PF(Value: Double); CDECL;
procedure Generators_Set_Phases(Value: Integer); CDECL;
function Generators_Get_Count(): Integer; CDECL;
function Generators_Get_idx(): Integer; CDECL;
procedure Generators_Set_idx(Value: Integer); CDECL;
function Generators_Get_Model(): Integer; CDECL;
procedure Generators_Set_Model(Value: Integer); CDECL;
function Generators_Get_kVArated(): Double; CDECL;
procedure Generators_Set_kVArated(Value: Double); CDECL;
function Generators_Get_Vmaxpu(): Double; CDECL;
function Generators_Get_Vminpu(): Double; CDECL;
procedure Generators_Set_Vmaxpu(Value: Double); CDECL;
procedure Generators_Set_Vminpu(Value: Double); CDECL;

implementation

uses
    CAPI_Constants,
    DSSCLassDefs,
    DSSGlobals,
    Generator,
    CktElement,
    SysUtils;

procedure Generators_Get_AllNames(var ResultPtr: PPAnsiChar; ResultCount: PInteger); CDECL;
var
    Result: PPAnsiCharArray;
    GenElem: TGeneratorObj;
    k: Integer;

begin
    Result := DSS_RecreateArray_PPAnsiChar(ResultPtr, ResultCount, (0) + 1);
    Result[0] := DSS_CopyStringAsPChar('NONE');
    if ActiveCircuit <> NIL then
        with ActiveCircuit do
            if Generators.ListSize > 0 then
            begin
                DSS_RecreateArray_PPAnsiChar(Result, ResultPtr, ResultCount, (Generators.ListSize - 1) + 1);
                k := 0;
                GenElem := Generators.First;
                while GenElem <> NIL do
                begin
                    Result[k] := DSS_CopyStringAsPChar(GenElem.Name);
                    Inc(k);
                    GenElem := Generators.Next;
                end;
            end;
end;

procedure Generators_Get_AllNames_GR(); CDECL;
// Same as Generators_Get_AllNames but uses global result (GR) pointers
begin
    Generators_Get_AllNames(GR_DataPtr_PPAnsiChar, GR_CountPtr_PPAnsiChar)
end;

//------------------------------------------------------------------------------
function Generators_Get_First(): Integer; CDECL;
var
    pGen: TGeneratorObj;

begin

    Result := 0;
    if ActiveCircuit <> NIL then
    begin
        pGen := ActiveCircuit.Generators.First;
        if pGen <> NIL then
        begin
            repeat
                if pGen.Enabled then
                begin
                    ActiveCircuit.ActiveCktElement := pGen;
                    Result := 1;
                end
                else
                    pGen := ActiveCircuit.Generators.Next;
            until (Result = 1) or (pGen = NIL);
        end
        else
            Result := 0;  // signify no more
    end;
end;
//------------------------------------------------------------------------------
function Generators_Get_Name_AnsiString(): Ansistring; inline;
var
    pGen: TGeneratorObj;

begin
    Result := '';
    if ActiveCircuit <> NIL then
    begin
        pGen := ActiveCircuit.Generators.Active;
        if pGen <> NIL then
        begin
            Result := pGen.Name;
        end
        else
            Result := '';  // signify no name
    end;

end;

function Generators_Get_Name(): PAnsiChar; CDECL;
begin
    Result := DSS_GetAsPAnsiChar(Generators_Get_Name_AnsiString());
end;
//------------------------------------------------------------------------------
function Generators_Get_Next(): Integer; CDECL;
var
    pGen: TGeneratorObj;

begin

    Result := 0;
    if ActiveCircuit <> NIL then
    begin
        pGen := ActiveCircuit.Generators.Next;
        if pGen <> NIL then
        begin
            repeat
                if pGen.Enabled then
                begin
                    ActiveCircuit.ActiveCktElement := pGen;
                    Result := ActiveCircuit.Generators.ActiveIndex;
                end
                else
                    pGen := ActiveCircuit.Generators.Next;
            until (Result > 0) or (pGen = NIL);
        end
        else
            Result := 0;  // signify no more
    end;

end;
//------------------------------------------------------------------------------
procedure Generators_Get_RegisterNames(var ResultPtr: PPAnsiChar; ResultCount: PInteger); CDECL;
var
    Result: PPAnsiCharArray;
    GeneratorClass: TGenerator;
    k: Integer;

begin
    GeneratorClass := DssClassList.Get(Classnames.Find('Generator'));
    Result := DSS_RecreateArray_PPAnsiChar(ResultPtr, ResultCount, (NumGenRegisters - 1) + 1);
    for k := 0 to NumGenRegisters - 1 do
    begin
        Result[k] := DSS_CopyStringAsPChar(GeneratorClass.RegisterNames[k + 1]);
    end;

end;

procedure Generators_Get_RegisterNames_GR(); CDECL;
// Same as Generators_Get_RegisterNames but uses global result (GR) pointers
begin
    Generators_Get_RegisterNames(GR_DataPtr_PPAnsiChar, GR_CountPtr_PPAnsiChar)
end;

//------------------------------------------------------------------------------
procedure Generators_Get_RegisterValues(var ResultPtr: PDouble; ResultCount: PInteger); CDECL;
var
    Result: PDoubleArray;
    Gen: TGeneratorObj;
    k: Integer;
begin

    if ActiveCircuit <> NIL then
    begin
        Gen := TGeneratorObj(ActiveCircuit.Generators.Active);
        if Gen <> NIL then
        begin
            Result := DSS_RecreateArray_PDouble(ResultPtr, ResultCount, (numGenRegisters - 1) + 1);
            for k := 0 to numGenRegisters - 1 do
            begin
                Result[k] := Gen.Registers[k + 1];
            end;
        end
        else
            Result := DSS_RecreateArray_PDouble(ResultPtr, ResultCount, (0) + 1);
    end
    else
    begin
        Result := DSS_RecreateArray_PDouble(ResultPtr, ResultCount, (0) + 1);
    end;


end;

procedure Generators_Get_RegisterValues_GR(); CDECL;
// Same as Generators_Get_RegisterValues but uses global result (GR) pointers
begin
    Generators_Get_RegisterValues(GR_DataPtr_PDouble, GR_CountPtr_PDouble)
end;

//------------------------------------------------------------------------------
function Generators_Get_ForcedON(): Wordbool; CDECL;
begin
    Result := FALSE;
    if ActiveCircuit <> NIL then
    begin
        with ActiveCircuit.Generators do
        begin
            if ActiveIndex <> 0 then
            begin
                Result := TGeneratorObj(Active).ForcedON;
            end;
        end;
    end;
end;
//------------------------------------------------------------------------------
procedure Generators_Set_ForcedON(Value: Wordbool); CDECL;
begin

    if ActiveCircuit <> NIL then
    begin
        with ActiveCircuit.Generators do
        begin
            if ActiveIndex <> 0 then
            begin
                TGeneratorObj(Active).ForcedON := Value;
            end;
        end;
    end;

end;
//------------------------------------------------------------------------------
procedure Generators_Set_Name(const Value: PAnsiChar); CDECL;
var
    activesave: Integer;
    Gen: TGeneratorObj;
    S: String;
    Found: Boolean;
begin


    if ActiveCircuit <> NIL then
    begin      // Search list of generators in active circuit for name
        with ActiveCircuit.Generators do
        begin
            S := Value;  // Convert to Pascal String
            Found := FALSE;
            ActiveSave := ActiveIndex;
            Gen := First;
            while Gen <> NIL do
            begin
                if (CompareText(Gen.Name, S) = 0) then
                begin
                    ActiveCircuit.ActiveCktElement := Gen;
                    Found := TRUE;
                    Break;
                end;
                Gen := Next;
            end;
            if not Found then
            begin
                DoSimpleMsg('Generator "' + S + '" Not Found in Active Circuit.', 5003);
                Gen := Get(ActiveSave);    // Restore active generator
                ActiveCircuit.ActiveCktElement := Gen;
            end;
        end;
    end;
end;
//------------------------------------------------------------------------------
function Generators_Get_kV(): Double; CDECL;
begin
    Result := -1.0;  // not set
    if ActiveCircuit <> NIL then
    begin
        with ActiveCircuit.Generators do
        begin
            if ActiveIndex <> 0 then
            begin
                Result := TGeneratorObj(Active).GenVars.kVGeneratorBase;
            end;
        end;
    end;
end;
//------------------------------------------------------------------------------
function Generators_Get_kvar(): Double; CDECL;
begin
    Result := 0.0;
    if ActiveCircuit <> NIL then
    begin
        with ActiveCircuit.Generators do
        begin
            if ActiveIndex <> 0 then
            begin
                Result := TGeneratorObj(Active).Presentkvar;
            end;
        end;
    end;
end;
//------------------------------------------------------------------------------
function Generators_Get_kW(): Double; CDECL;
begin
    Result := 0.0;
    if ActiveCircuit <> NIL then
    begin
        with ActiveCircuit.Generators do
        begin
            if ActiveIndex <> 0 then
            begin
                Result := TGeneratorObj(Active).PresentkW;
            end;
        end;
    end;
end;
//------------------------------------------------------------------------------
function Generators_Get_PF(): Double; CDECL;
begin
    Result := 0.0;
    if ActiveCircuit <> NIL then
    begin
        with ActiveCircuit.Generators do
        begin
            if ActiveIndex <> 0 then
            begin
                Result := TGeneratorObj(Active).PowerFactor;
            end;
        end;
    end;
end;
//------------------------------------------------------------------------------
function Generators_Get_Phases(): Integer; CDECL;
begin
    Result := 0;  // not set
    if ActiveCircuit <> NIL then
    begin
        with ActiveCircuit.Generators do
        begin
            if ActiveIndex <> 0 then
            begin
                Result := TGeneratorObj(Active).nphases;
            end;
        end;
    end;
end;
//------------------------------------------------------------------------------
procedure Generators_Set_kV(Value: Double); CDECL;
begin

    if ActiveCircuit <> NIL then
    begin
        with ActiveCircuit.Generators do
        begin
            if ActiveIndex <> 0 then
            begin
                TGeneratorObj(Active).PresentkV := Value;
            end;
        end;
    end;

end;
//------------------------------------------------------------------------------
procedure Generators_Set_kvar(Value: Double); CDECL;
begin
    if ActiveCircuit <> NIL then
    begin
        with ActiveCircuit.Generators do
        begin
            if ActiveIndex <> 0 then
            begin
                TGeneratorObj(Active).Presentkvar := Value;
            end;
        end;
    end;
end;
//------------------------------------------------------------------------------
procedure Generators_Set_kW(Value: Double); CDECL;
begin
    if ActiveCircuit <> NIL then
    begin
        with ActiveCircuit.Generators do
        begin
            if ActiveIndex <> 0 then
            begin
                TGeneratorObj(Active).PresentkW := Value;
            end;
        end;
    end;
end;
//------------------------------------------------------------------------------
procedure Generators_Set_PF(Value: Double); CDECL;
begin
    if ActiveCircuit <> NIL then
    begin
        with ActiveCircuit.Generators do
        begin
            if ActiveIndex <> 0 then
            begin
                TGeneratorObj(Active).PowerFactor := Value;
            end;
        end;
    end;
end;
//------------------------------------------------------------------------------
procedure Generators_Set_Phases(Value: Integer); CDECL;
begin
    if ActiveCircuit <> NIL then
    begin
        with ActiveCircuit.Generators do
        begin
            if ActiveIndex <> 0 then
            begin
                TGeneratorObj(Active).Nphases := Value;
            end;
        end;
    end;
end;
//------------------------------------------------------------------------------
function Generators_Get_Count(): Integer; CDECL;
begin
    if Assigned(Activecircuit) then
        Result := ActiveCircuit.Generators.ListSize;
end;
//------------------------------------------------------------------------------
function Generators_Get_idx(): Integer; CDECL;
begin
    if ActiveCircuit <> NIL then
        Result := ActiveCircuit.Generators.ActiveIndex
    else
        Result := 0;
end;
//------------------------------------------------------------------------------
procedure Generators_Set_idx(Value: Integer); CDECL;
var
    pGen: TGeneratorObj;
begin
    if ActiveCircuit <> NIL then
    begin
        pGen := ActiveCircuit.Generators.Get(Value);
        if pGen <> NIL then
            ActiveCircuit.ActiveCktElement := pGen;
    end;

end;
//------------------------------------------------------------------------------
function Generators_Get_Model(): Integer; CDECL;
begin
    Result := -1;
    if ActiveCircuit <> NIL then
    begin
        with ActiveCircuit.Generators do
        begin
            if ActiveIndex <> 0 then
            begin
                Result := TGeneratorObj(Active).GenModel;
            end;
        end;
    end;
end;
//------------------------------------------------------------------------------
procedure Generators_Set_Model(Value: Integer); CDECL;
begin
    if ActiveCircuit <> NIL then
    begin
        with ActiveCircuit.Generators do
        begin
            if ActiveIndex <> 0 then
            begin
                with TGeneratorObj(Active) do
                begin
                    GenModel := Value;
                     // Handle side effect
                    if GenModel = 3 then
                        ActiveCircuit.Solution.SolutionInitialized := FALSE;
                end;
            end;
        end;
    end;
end;
//------------------------------------------------------------------------------
function Generators_Get_kVArated(): Double; CDECL;
begin
    Result := -1.0;
    if ActiveCircuit <> NIL then
    begin
        with ActiveCircuit.Generators do
        begin
            if ActiveIndex <> 0 then
            begin
                Result := TGeneratorObj(Active).Genvars.kVArating;
            end;
        end;
    end;
end;
//------------------------------------------------------------------------------
procedure Generators_Set_kVArated(Value: Double); CDECL;
begin
    if ActiveCircuit <> NIL then
    begin
        with ActiveCircuit.Generators do
        begin
            if ActiveIndex <> 0 then
            begin
                with TGeneratorObj(Active) do
                begin
                    Genvars.kVArating := Value;
                end;
            end;
        end;
    end;
end;
//------------------------------------------------------------------------------
function Generators_Get_Vmaxpu(): Double; CDECL;
begin
    Result := -1.0;
    if ActiveCircuit <> NIL then
    begin
        with ActiveCircuit.Generators do
        begin
            if ActiveIndex <> 0 then
            begin
                Result := TGeneratorObj(Active).Vmaxpu;
            end;
        end;
    end;
end;
//------------------------------------------------------------------------------
function Generators_Get_Vminpu(): Double; CDECL;
begin
    Result := -1.0;
    if ActiveCircuit <> NIL then
    begin
        with ActiveCircuit.Generators do
        begin
            if ActiveIndex <> 0 then
            begin
                Result := TGeneratorObj(Active).Vminpu;
            end;
        end;
    end;
end;
//------------------------------------------------------------------------------
procedure Generators_Set_Vmaxpu(Value: Double); CDECL;
begin
    if ActiveCircuit <> NIL then
    begin
        with ActiveCircuit.Generators do
        begin
            if ActiveIndex <> 0 then
            begin
                with TGeneratorObj(Active) do
                begin
                    VMaxPu := Value;
                end;
            end;
        end;
    end;
end;
//------------------------------------------------------------------------------
procedure Generators_Set_Vminpu(Value: Double); CDECL;
begin
    if ActiveCircuit <> NIL then
    begin
        with ActiveCircuit.Generators do
        begin
            if ActiveIndex <> 0 then
            begin
                with TGeneratorObj(Active) do
                begin
                    VMinPu := Value;
                end;
            end;
        end;
    end;
end;
//------------------------------------------------------------------------------
end.
