/*
 * Create data type and functions for calculating blocks rewards data
 */

BEGIN;

-- Create new data type which will store block rewards info
CREATE TYPE blockRewards AS (supply bigint, start int, distance bigint, milestones bigint[][]);

-- Create function that returns blocks rewards data
-- @IMMUTABLE - always returns the same result
CREATE FUNCTION getBlockRewards() RETURNS blockRewards LANGUAGE PLPGSQL IMMUTABLE AS $$
	DECLARE
		res        blockRewards;
		supply     bigint     = 18000000000000000; -- Initial supply
		start      int        = 1; -- Start rewards at block (n)
		distance   bigint     = 240; -- Distance between each milestone (real:172800)
		milestones bigint[][] = ARRAY[   -- Milestones [number, reward]
			[0, 5000000000],
			[1, 5000000000],
			[2, 5000000000],
			[3, 5000000000],
			[4, 5000000000],
			[5, 5000000000],
			[6, 4000000000],
			[7, 4000000000],
			[8, 4000000000],
			[9, 4000000000],
			[10, 4000000000],
			[11, 4000000000],
			[12, 3500000000],
			[13, 3500000000],
			[14, 3500000000],
			[15, 3500000000],
			[16, 3500000000],
			[17, 3500000000],
			[18, 3000000000],
			[19, 3000000000],
			[20, 3000000000],
			[21, 3000000000],
			[22, 3000000000],
			[23, 3000000000],
			[24, 2500000000],
			[25, 2500000000],
			[26, 2500000000],
			[27, 2500000000],
			[28, 2500000000],
			[29, 2500000000],
			[30, 2500000000],
			[31, 2500000000],
			[32, 2500000000],
			[33, 2500000000],
			[34, 2500000000],
			[35, 2500000000],
			[36, 2500000000],
			[37, 2500000000],
			[38, 2500000000],
			[39, 2500000000],
			[40, 2500000000],
			[41, 2500000000],
			[42, 2500000000],
			[43, 2500000000],
			[44, 2500000000],
			[45, 2500000000],
			[46, 2500000000],
			[47, 2500000000],
			[48, 2500000000],
			[49, 2500000000],
			[50, 2500000000],
			[51, 2500000000],
			[52, 2500000000],
			[53, 2500000000],
			[54, 2500000000],
			[55, 2500000000],
			[56, 2500000000],
			[57, 2500000000],
			[58, 2500000000],
			[59, 2500000000],
			[60, 2500000000],
			[61, 2500000000],
			[62, 2500000000],
			[63, 2500000000],
			[64, 2500000000],
			[65, 2500000000],
			[66, 2500000000],
			[67, 2500000000],
			[68, 2500000000],
			[69, 2500000000],
			[70, 2500000000],
			[71, 2500000000],
			[72, 2500000000],
			[73, 2500000000],
			[74, 2500000000],
			[75, 2500000000],
			[76, 2500000000],
			[77, 2500000000],
			[78, 2500000000],
			[79, 2500000000],
			[80, 2500000000],
			[81, 2500000000],
			[82, 2500000000],
			[83, 2500000000],
			[84, 2000000000],
			[85, 2000000000],
			[86, 2000000000],
			[87, 2000000000],
			[88, 2000000000],
			[89, 2000000000],
			[90, 2000000000],
			[91, 2000000000],
			[92, 2000000000],
			[93, 2000000000],
			[94, 2000000000],
			[95, 2000000000],
			[96, 2000000000],
			[97, 2000000000],
			[98, 2000000000],
			[99, 2000000000],
			[100, 2000000000],
			[101, 2000000000],
			[102, 2000000000],
			[103, 2000000000],
			[104, 2000000000],
			[105, 2000000000],
			[106, 2000000000],
			[107, 2000000000],
			[108, 2000000000],
			[109, 2000000000],
			[110, 2000000000],
			[111, 2000000000],
			[112, 2000000000],
			[113, 2000000000],
			[114, 2000000000],
			[115, 2000000000],
			[116, 2000000000],
			[117, 2000000000],
			[118, 2000000000],
			[119, 2000000000],
			[120, 2000000000],
			[121, 2000000000],
			[122, 2000000000],
			[123, 2000000000],
			[124, 2000000000],
			[125, 2000000000],
			[126, 2000000000],
			[127, 2000000000],
			[128, 2000000000],
			[129, 2000000000],
			[130, 2000000000],
			[131, 2000000000],
			[132, 2000000000],
			[133, 2000000000],
			[134, 2000000000],
			[135, 2000000000],
			[136, 2000000000],
			[137, 2000000000],
			[138, 2000000000],
			[139, 2000000000],
			[140, 2000000000],
			[141, 2000000000],
			[142, 2000000000],
			[143, 2000000000],
			[144, 1000000000],
			[145, 1000000000],
			[146, 1000000000],
			[147, 1000000000],
			[148, 1000000000],
			[149, 1000000000],
			[150, 1000000000],
			[151, 1000000000],
			[152, 1000000000],
			[153, 1000000000],
			[154, 1000000000],
			[155, 1000000000],
			[156, 900000000],
			[157, 900000000],
			[158, 900000000],
			[159, 900000000],
			[160, 900000000],
			[161, 900000000],
			[162, 900000000],
			[163, 900000000],
			[164, 900000000],
			[165, 900000000],
			[166, 900000000],
			[167, 900000000],
			[168, 800000000],
			[169, 800000000],
			[170, 800000000],
			[171, 800000000],
			[172, 800000000],
			[173, 800000000],
			[174, 800000000],
			[175, 800000000],
			[176, 800000000],
			[177, 800000000],
			[178, 800000000],
			[179, 800000000],
			[180, 700000000],
			[181, 700000000],
			[182, 700000000],
			[183, 700000000],
			[184, 700000000],
			[185, 700000000],
			[186, 700000000],
			[187, 700000000],
			[188, 700000000],
			[189, 700000000],
			[190, 700000000],
			[191, 700000000],
			[192, 600000000],
			[193, 600000000],
			[194, 600000000],
			[195, 600000000],
			[196, 600000000],
			[197, 600000000],
			[198, 600000000],
			[199, 600000000],
			[200, 600000000],
			[201, 600000000],
			[202, 600000000],
			[203, 600000000],
			[204, 500000000],
			[205, 500000000],
			[206, 500000000],
			[207, 500000000],
			[208, 500000000],
			[209, 500000000],
			[210, 500000000],
			[211, 500000000],
			[212, 500000000],
			[213, 500000000],
			[214, 500000000],
			[215, 500000000],
			[216, 400000000],
			[217, 400000000],
			[218, 400000000],
			[219, 400000000],
			[220, 400000000],
			[221, 400000000],
			[222, 400000000],
			[223, 400000000],
			[224, 400000000],
			[225, 400000000],
			[226, 400000000],
			[227, 400000000],
			[228, 300000000],
			[229, 300000000],
			[230, 300000000],
			[231, 300000000],
			[232, 300000000],
			[233, 300000000],
			[234, 300000000],
			[235, 300000000],
			[236, 300000000],
			[237, 300000000],
			[238, 300000000],
			[239, 300000000],
			[240, 200000000],
			[241, 200000000],
			[242, 200000000],
			[243, 200000000],
			[244, 200000000],
			[245, 200000000],
			[246, 200000000],
			[247, 200000000],
			[248, 200000000],
			[249, 200000000],
			[250, 200000000],
			[251, 200000000],
			[252, 100000000],
			[253, 100000000],
			[254, 100000000],
			[255, 100000000],
			[256, 100000000],
			[257, 100000000],
			[258, 100000000],
			[259, 100000000],
			[260, 100000000],
			[261, 100000000],
			[262, 100000000],
			[263, 100000000]
		];
	BEGIN
		res.supply     = supply;
		res.start      = start;
		res.distance   = distance;
		res.milestones = milestones;
	RETURN res;
END $$;

-- Create function that returns blocks rewards data
-- @IMMUTABLE - always returns the same result for the same argument
CREATE FUNCTION calcBlockReward(block_height int) RETURNS bigint LANGUAGE PLPGSQL IMMUTABLE AS $$
	DECLARE
		r blockRewards;
		m int[];
		reward bigint;
	BEGIN
		-- Return NULL if supplied height is invalid
		IF block_height IS NULL OR block_height <= 0 THEN RETURN NULL; END IF;

		-- Get blocks rewards data
		SELECT * FROM getBlockRewards() INTO r;

		-- Iterating over milestones array, m - milestone data (m[1] - milestone number, m[2] - milestone reward)
		FOREACH m SLICE 1 IN ARRAY r.milestones
		LOOP
			-- If height is inside milestone - set reward and exit loop
			IF block_height <= r.start+r.distance*m[1] THEN
				reward := m[2];
				EXIT;
			END IF;
		END LOOP;

		-- If reward exceed last milestone - set reward from last milestone
		IF reward IS NULL THEN
			reward := m[2];
		END IF;
	-- Return calculated reward
	RETURN reward;
END $$;

-- Create function that calculates current supply
-- @STABLE - for the same argument returns the same result within a single table scan
CREATE FUNCTION calcSupply(block_height int DEFAULT NULL) RETURNS bigint LANGUAGE PLPGSQL STABLE AS $$
	DECLARE
		r blockRewards;
		m int[];
		height   int;
		step     bigint;
		blocks   bigint;
		overflow bigint;
	BEGIN
		-- Return NULL if supplied height is invalid
		IF block_height <= 0 THEN RETURN NULL; END IF;

		-- Get blocks rewards data
		SELECT * FROM getBlockRewards() INTO r;
		IF block_height IS NULL THEN
			-- If no height is supplied - we use last block height for calculations
			SELECT b.height INTO height FROM blocks b ORDER BY b.height DESC LIMIT 1;
		ELSE
			-- If height is supplied - use it for calculations
			height := block_height;
		END IF;

		-- Iterating over milestones array, m - milestone data (m[1] - milestone number, m[2] - milestone reward)
		FOREACH m SLICE 1 IN ARRAY r.milestones
		LOOP
			-- Calculate step (last block of milestone)
			step := r.start-1+r.distance*m[1];
			-- Calculate amount of blocks in milestone
			blocks := height-step;
			-- If amount of blocks in milestone is positive and lower or equal distance
			IF blocks > 0 AND blocks <= r.distance THEN
				-- Calculate rewards for blocks in milestone and add to supply
				r.supply := r.supply + blocks*m[2];
			-- If amount of blocks in milestone is grater than distance
			ELSIF blocks > r.distance THEN
				-- Use distance for calculate rewards for blocks in milestone and add to supply
				r.supply := r.supply + r.distance*m[2];
			-- If amount of blocks in milestone is negative - no need to loop further, so exit the loop
			ELSE EXIT;
			END IF;
		END LOOP;

		-- Calculate amount of remaining blocks after last milestone
		overflow := height-(step+r.distance);
		IF overflow > 0 THEN
			-- Calculate rewards for remaining blocks and add to supply
			r.supply := r.supply + overflow*m[2];
		END IF;
	-- Return calculated supply
	RETURN r.supply;
END $$;

COMMIT;
