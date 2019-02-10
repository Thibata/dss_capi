unit CAPI_DSSProperty;

{$inline on}

interface

uses
    CAPI_Utils;

function DSSProperty_Get_Description(): PAnsiChar; CDECL;
function DSSProperty_Get_Name(): PAnsiChar; CDECL;
function DSSProperty_Get_Val(): PAnsiChar; CDECL;
procedure DSSProperty_Set_Val(const Value: PAnsiChar); CDECL;
procedure DSSProperty_Set_Index(const Value: Integer); CDECL;
procedure DSSProperty_Set_Name(const Value: PAnsiChar); CDECL;

implementation

uses
    CAPI_Constants,
    CAPI_Globals,
    DSSClass,
    DSSGlobals,
    Executive,
    SysUtils;

function DSSProperty_Get_Description_AnsiString(): Ansistring; inline;
begin
    Result := '';
    if (ActiveCircuit <> NIL) and (FPropIndex <> 0) {and (FPropClass <> Nil)} then
        with  ActiveDSSObject.ParentClass do
            if FPropIndex <= NumProperties then
                Result := PropertyHelp^[FPropIndex];

end;

function DSSProperty_Get_Description(): PAnsiChar; CDECL;
begin
    Result := DSS_GetAsPAnsiChar(DSSProperty_Get_Description_AnsiString());
end;
//------------------------------------------------------------------------------
function DSSProperty_Get_Name_AnsiString(): Ansistring; inline;
begin
    Result := '';
    if (ActiveCircuit <> NIL) and (FPropIndex <> 0) {and (FPropClass <> Nil)} then
        with  ActiveDSSObject.ParentClass do
            if FPropIndex <= NumProperties then
                Result := PropertyName^[FPropIndex];

end;

function DSSProperty_Get_Name(): PAnsiChar; CDECL;
begin
    Result := DSS_GetAsPAnsiChar(DSSProperty_Get_Name_AnsiString());
end;
//------------------------------------------------------------------------------
function DSSProperty_Get_Val_AnsiString(): Ansistring; inline;
begin
    Result := '';
    if ActiveCircuit = NIL then
        Exit;
    with ActiveDSSObject do
    begin
        if FPropIndex <= ParentClass.NumProperties then
            Result := PropertyValue[ParentClass.PropertyIdxMap[FPropIndex]];
    end;
end;

function DSSProperty_Get_Val(): PAnsiChar; CDECL;
begin
    Result := DSS_GetAsPAnsiChar(DSSProperty_Get_Val_AnsiString());
end;
//------------------------------------------------------------------------------
procedure DSSProperty_Set_Val(const Value: PAnsiChar); CDECL;
begin
    if ActiveCircuit = NIL then
        Exit;

    with ActiveDSSObject do
    begin
        if (FPropIndex > ParentClass.NumProperties) or (FPropIndex < 1) then
        begin
            DoSimpleMsg(Format(
                'Invalid property index %d for "%s.%s"',
                [FPropIndex, ParentClass.Name, Name]
                ), 33001);
            Exit;
        end;
        DSSExecutive.Command :=
            'Edit ' + ParentClass.Name + '.' + Name + ' ' +
            ParentClass.PropertyName^[FPropIndex] + '=' + String(Value);
    end;
end;
//------------------------------------------------------------------------------
procedure DSSProperty_Set_Index(const Value: Integer); CDECL;
begin
    if ActiveCircuit <> NIL then
    begin
        FPropIndex := Value + 1;
    end;
end;
//------------------------------------------------------------------------------
procedure DSSProperty_Set_Name(const Value: PAnsiChar); CDECL;
var
    i: Integer;
begin
    if ActiveCircuit <> NIL then
    begin
        FPropClass := ActiveDSSObject.ParentClass;
        FPropIndex := 0;
        if FPropClass <> NIL then
            with FPropClass do
                for i := 1 to NumProperties do
                begin
                    if CompareText(Value, PropertyName^[i]) = 0 then
                    begin
                        FPropIndex := i;
                        Break;
                    end;
                end;
    end;
end;
//------------------------------------------------------------------------------
end.
