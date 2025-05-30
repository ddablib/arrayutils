{
 * Registers example code unit so that it is run when the demo program is run.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit Registrar;

interface

uses
  SysUtils,
  Generics.Collections;

type
  TProcedureInfo = record
    Name: string;
    Proc: TProcedure;
    constructor Create(AName: string; AProc: TProcedure);
  end;

  TRegistrar = class
  strict private
    class var
      fRegister: TDictionary<string,TArray<TProcedureInfo>>;
  public
    class constructor Create;
    class destructor Destroy;
    class procedure Add(const MethodName: string;
      const Procs: TArray<TProcedureInfo>);
    class function GetProcs(const MethodName: string): TArray<TProcedureInfo>;
    class function MethodNames: TArray<string>;
  end;

implementation

uses
  Generics.Defaults;

{ TRegistrar }

class procedure TRegistrar.Add(const MethodName: string;
  const Procs: TArray<TProcedureInfo>);
begin
  fRegister.Add(MethodName, Procs);
end;

class constructor TRegistrar.Create;
begin
  fRegister := TDictionary<string,TArray<TProcedureInfo>>.Create;
end;

class destructor TRegistrar.Destroy;
begin
  fRegister.Free;
end;

class function TRegistrar.GetProcs(const MethodName: string):
  TArray<TProcedureInfo>;
begin
  Result := fRegister[MethodName];
end;

class function TRegistrar.MethodNames: TArray<string>;
var
  List: TList<string>;
  Key: string;
  Comparer: IComparer<string>;
begin
  List := TList<string>.Create;
  try
    for Key in fRegister.Keys do
      List.Add(Key);
    // Set Comparer to avoid memory leak created if TDelegatedComparer called
    // directly within List.Sort() method call
    Comparer := TDelegatedComparer<string>.Create(
      function (const L, R: string): Integer
      begin
        Result := CompareStr(L, R);
      end
    );
    List.Sort(Comparer);
    Result := List.ToArray;
  finally
    List.Free;
  end;
end;

{ TProcedureInfo }

constructor TProcedureInfo.Create(AName: string; AProc: TProcedure);
begin
  Name := AName;
  Proc := AProc;
end;

end.
