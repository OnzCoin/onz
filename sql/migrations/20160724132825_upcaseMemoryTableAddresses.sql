/* Upcase Memory Table Addresses
 *
 */

BEGIN;

UPDATE "mem_accounts" AS m
   SET "balance" = (m."balance" + l."balance"),
       "u_balance" = (m."u_balance" + l."u_balance")
  FROM (
    SELECT "address", "balance", "u_balance"
      FROM "mem_accounts"
     WHERE "address" LIKE 'onz%'
  ) AS "l"
 WHERE m."address" = l."address";

DELETE FROM "mem_accounts" WHERE "address" LIKE 'onz%' AND "publicKey" IS NULL;

/*
UPDATE "mem_accounts" SET "address" = UPPER("address") WHERE "address" LIKE 'onz%';

UPDATE "mem_round" SET "address" = UPPER("address") WHERE "address" LIKE 'onz%';

UPDATE "mem_accounts2delegates" SET "accountId" = UPPER("accountId") WHERE "accountId" LIKE 'onz%';

UPDATE "mem_accounts2u_delegates" SET "accountId" = UPPER("accountId") WHERE "accountId" LIKE 'onz%';

UPDATE "mem_accounts2multisignatures" SET "accountId" = UPPER("accountId") WHERE "accountId" LIKE 'onz%';

UPDATE "mem_accounts2u_multisignatures" SET "accountId" = UPPER("accountId") WHERE "accountId" LIKE 'onz%';
*/

COMMIT;
