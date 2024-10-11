exo1

  

delimiter --
create procedure copy_couple()
declare v_nompers,prenompers varchar(100);
declare v_numpers int ;
DECLARE
  CURSOR cur_personnel IS
    SELECT nompers, prenompers, numpers FROM PERSONNEL WHERE numpers BETWEEN 1 AND 21;
  v_nompers CLIENT.nomcli%TYPE;
  v_prenompers CLIENT.prenomcli%TYPE;
  v_numpers CLIENT.numcli%TYPE;
BEGIN
  OPEN cur_personnel;
  LOOP
    FETCH cur_personnel INTO v_nompers, v_prenompers, v_numpers;
    EXIT WHEN cur_personnel%NOTFOUND;
    
    INSERT INTO CLIENT (numcli, nomcli, prenomcli)
    VALUES (v_numpers, v_nompers, v_prenompers);
  END LOOP;
  CLOSE cur_personnel;
END--
*************



  

exo2

delimiter --
create procedure recuperer()

begin
declare    v_nomcli, v_prenomcli ,varchar(100);
declare v_numcli int ;


DECLARE
  CURSOR cur_max_client IS
    SELECT numcli, nomcli, prenomcli FROM CLIENT ORDER BY numcli DESC;
  v_numcli CLIENT.numcli%TYPE;
  v_nomcli CLIENT.nomcli%TYPE;
  v_prenomcli CLIENT.prenomcli%TYPE;
BEGIN
  OPEN cur_max_client;
  FETCH cur_max_client INTO v_numcli, v_nomcli, v_prenomcli;
  
  INSERT INTO PERSONNEL (numpers, nompers, prenompers)
  VALUES (v_numcli, v_nomcli, v_prenomcli);
  
  CLOSE cur_max_client;
END--

  
 *********
exo3



  
delimiter --
create procedure open_compte()

begin
declare   solde float;
declare date_ccl date ;
declare numcli , numccl ,numtype_ccl, int , numpers;
DECLARE
  CURSOR cur_personnel for
    SELECT numpers FROM PERSONNEL;
  v_numpers PERSONNEL.numpers%TYPE;
BEGIN
  OPEN cur_personnel;
  LOOP
    FETCH cur_personnel INTO v_numpers;
    EXIT WHEN cur_personnel%NOTFOUND;
    
    INSERT INTO COMPTE_CLIENT (numcli, numccl, numtype_ccl, date_ccl, numpers, Solde)
    VALUES (v_numpers, SEQ_COMPTE.NEXTVAL, 1, SYSDATE, v_numpers, 500);
  END LOOP;
  CLOSE cur_personnel;
END--



**********
EXO4


  
delimiter --
create procedure livrer()

begin
declare     Solde float ;
declare numcli,numpers, numccl, numtype_ccl, int ;
declare  date_ccl date ;
DECLARE
  CURSOR cur_even_personnel IS
    SELECT numpers, solde FROM COMPTE_CLIENT WHERE MOD(numpers, 2) = 0 AND numtype_ccl = 1;
  v_numpers PERSONNEL.numpers%TYPE;
  v_solde COMPTE_CLIENT.solde%TYPE;
BEGIN
  OPEN cur_even_personnel;
  LOOP
    FETCH cur_even_personnel INTO v_numpers, v_solde;
    EXIT WHEN cur_even_personnel%NOTFOUND;

     
    INSERT INTO COMPTE_CLIENT (numcli, numccl, numtype_ccl, date_ccl, numpers, Solde)
    VALUES (v_numpers, SEQ_COMPTE.NEXTVAL, 2, SYSDATE, v_numpers, v_solde - 500);

    
    UPDATE COMPTE_CLIENT
    SET Solde = 500
    WHERE numpers = v_numpers AND numtype_ccl = 1;
  END LOOP;
  CLOSE cur_even_personnel;
END--
