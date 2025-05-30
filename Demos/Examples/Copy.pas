{
 * Example code for TArrayUtils.Copy<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit Copy;

interface

implementation

uses
  Classes,
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure Copy_Eg1;
var
  A, B: TArray<Integer>;
  C, D: TArray<TStrings>;
  O1, O2, O3: TStrings;
  Idx: Integer;
begin
  A := TArray<Integer>.Create(1, 2, 3);
  B := TArrayUtils.Copy<Integer>(A);
  Assert(TArrayUtils.Equal<Integer>(A, B));

  O1 := TStringList.Create;
  O2 := TStringList.Create;
  O3 := TStringList.Create;
  O1.Add('a');
  O2.Add('b'); O2.Add('c');
  O3.Add('d');

  C := TArray<TStrings>.Create(O1, O2, O3);
  D := TArrayUtils.Copy<TStrings>(C);

  for Idx := Low(C) to High(C) do
    // these array elements refer to the same object references
    Assert(Pointer(C[Idx]) = Pointer(D[Idx]));

  Assert(D[0].Text = C[0].Text);
  C[0].Add('x');    // also updates D[0];
  Assert(D[0].Text = C[0].Text);

  for Idx := Low(C) to High(C) do
    C[Idx].Free;    // also frees D[Idx]
end;

procedure Copy_Eg2;
var
  C, D: TArray<TStrings>;
  O1, O2, O3: TStrings;
  Idx: Integer;
  Cloner: TArrayUtils.TCloner<TStrings>;
begin
  O1 := TStringList.Create;
  O2 := TStringList.Create;
  O3 := TStringList.Create;
  O1.Add('a');
  O2.Add('b'); O2.Add('c');
  O3.Add('d');

  Cloner := function(const AElem: TStrings): TStrings
    var
      S: string;
    begin
      Result := TStringList.Create;
      for S in AElem do
        Result.Add(S);
    end;

  C := TArray<TStrings>.Create(O1, O2, O3);
  D := TArrayUtils.Copy<TStrings>(C, Cloner);

  for Idx := Low(C) to High(C) do
    // these array elements refer to different object references
    Assert(Pointer(C[Idx]) <> Pointer(D[Idx]));

  Assert(D[0].Text = C[0].Text);
  C[0].Add('x');    // does not update D[0];
  Assert(D[0].Text <> C[0].Text);

  for Idx := Low(C) to High(C) do
    C[Idx].Free;
  for Idx := Low(D) to High(D) do
    D[Idx].Free;    // these are separate objects to those in C
end;

initialization

TRegistrar.Add(
  'Copy<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('Copy_Eg1', @Copy_Eg1),
    TProcedureInfo.Create('Copy_Eg2', @Copy_Eg2)
  )
);

end.
