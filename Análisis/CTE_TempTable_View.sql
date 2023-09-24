--USE CTE
 WITH PopvsVac (CONTINENT,LOCATION, DATE,POPULATION, NEW_VACCINATIONS, PERSONAS_VACUNADAS)
 AS
  (
	 SELECT  
		MT.continent, 
		MT.location,
		MT.date, 
		MT.population, 
		VC.new_vaccinations,
		SUM(CAST(VC.new_vaccinations AS FLOAT)) OVER (PARTITION BY MT.LOCATION ORDER BY MT.LOCATION,MT.DATE)
	  AS PERSONAS_VACUNADAS
	FROM 
	  [BD_PROJECT_COVID].[dbo].[COVID_MUERTES] MT 
	  JOIN 
	  [BD_PROJECT_COVID].[dbo].[COVID_VACUNAS] VC
	  ON MT.location = VC.location AND MT.date = VC.date
	WHERE MT.continent IS NOT NULL 
  )
SELECT *, (PERSONAS_VACUNADAS/POPULATION)*100 FROM PopvsVac


--TEMP TABLE
 DROP TABLE IF EXISTS #PorcentajeVacunadaPoblacion
 CREATE TABLE #PorcentajeVacunadaPoblacion
 (
  CONTINENT NVARCHAR (255),
  LOCATION NVARCHAR(255),
  DATE DATETIME,
  POPULATION NUMERIC,
  NEW_VACCINATIONS NUMERIC,
  PERSONAS_VACUNADAS NUMERIC
 )

 INSERT INTO #PorcentajeVacunadaPoblacion
 SELECT  
	MT.continent, 
	MT.location, MT.date, 
	MT.population, 
	VC.new_vaccinations,
	SUM(CAST(VC.new_vaccinations AS FLOAT)) OVER (PARTITION BY MT.LOCATION ORDER BY MT.LOCATION,MT.DATE)
  AS PERSONAS_VACUNADAS
FROM 
  [BD_PROJECT_COVID].[dbo].[COVID_MUERTES] MT 
  JOIN [BD_PROJECT_COVID].[dbo].[COVID_VACUNAS] VC
  ON MT.location = VC.location AND MT.date = VC.date
WHERE MT.continent IS NOT NULL 
 
SELECT *, (PERSONAS_VACUNADAS/POPULATION)*100 FROM #PorcentajeVacunadaPoblacion


-- CREANDO VISTAS PARA VISUALIZACIONES POSTERIORES


CREATE VIEW PORCENT_PoblacionVacunada
AS
SELECT
	MT.continent, 
	MT.location, 
	MT.date, 
	MT.population, 
	VC.new_vaccinations,
	SUM(CAST(VC.new_vaccinations AS FLOAT)) OVER (PARTITION BY MT.LOCATION ORDER BY MT.LOCATION,MT.DATE)
  AS PERSONAS_VACUNADAS
FROM 
  [BD_PROJECT_COVID].[dbo].[COVID_MUERTES] MT 
  JOIN 
  [BD_PROJECT_COVID].[dbo].[COVID_VACUNAS] VC
  ON MT.location = VC.location AND MT.date = VC.date
WHERE MT.continent IS NOT NULL 

SELECT * FROM PORCENT_PoblacionVacunada
