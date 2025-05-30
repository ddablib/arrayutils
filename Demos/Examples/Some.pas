{
 * Example code for TArrayUtils.Some<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit Some;

interface

implementation

uses
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure Some_Eg1;
var
  A, B, C: TArray<Integer>;
  Constraint: TArrayUtils.TConstraint<Integer>;
begin
  A := TArray<Integer>.Create(1, 2, 3, 4, 5, 3);
  B := TArray<Integer>.Create(4, 5, 6);
  C := TArray<Integer>.Create(1, 2, 1);
  Constraint := function (const AElem: Integer): Boolean
    begin
      Result := AElem >= 4;
    end;
  Assert(TArrayUtils.Some<Integer>(A, Constraint) = True);
  Assert(TArrayUtils.Some<Integer>(B, Constraint) = True);
  Assert(TArrayUtils.Some<Integer>(C, Constraint) = False);
end;

procedure Some_Eg2;
var
  Constraint: TArrayUtils.TConstraintEx<Integer>;
  A, B, C, D: TArray<Integer>;
begin
  Constraint := function (const AElem: Integer; const AIndex: Integer;
    const A: array of Integer): Boolean
    var
      Distance: Integer;
    begin
      // True iff distance between element and prior element <=1
      // Assume that single element arrays meet the criteria
      if Length(A) = 1 then
        Exit(True);
      Assert(A[AIndex] = AElem);
      if AIndex = 0 then
        Exit(False);
      Distance := Abs(A[AIndex] - A[AIndex - 1]);
      Result := Distance <= 1;
    end;

  A := TArray<Integer>.Create(0, 1, 0, 1, 2, 1, 2, 1, 0);
  B := TArray<Integer>.Create(0, 1, 2, 0, 1, 2);
  C := TArray<Integer>.Create(0, 2, 4);
  D := TArray<Integer>.Create(42);
  Assert(TArrayUtils.Some<Integer>(A, Constraint) = True);
  Assert(TArrayUtils.Some<Integer>(B, Constraint) = True);
  Assert(TArrayUtils.Some<Integer>(C, Constraint) = False);
  Assert(TArrayUtils.Some<Integer>(D, Constraint) = True);
end;

initialization

TRegistrar.Add(
  'Some<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('Some_Eg1', @Some_Eg1),
    TProcedureInfo.Create('Some_Eg2', @Some_Eg2)
  )
);

end.
