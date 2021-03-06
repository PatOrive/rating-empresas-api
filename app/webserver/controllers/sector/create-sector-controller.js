"use strict";

const uuidV4 = require("uuid/v4");
const Joi = require("@hapi/joi");
const mysqlPool = require("../../../database/mysql-pool");

async function validateSchema(payload) {
  const schema = Joi.object({
    sector: Joi.string()
      .min(1)
      .max(45)
      .required(),
  });

  Joi.assert(payload, schema);
}

async function createSector(req, res) {
  const sectorData = { ...req.body };

  try {
    await validateSchema(sectorData);
  } catch (e) {
    console.error(e);
    return res.status(400).send("Data are not valid");
  }

  const id = uuidV4();
  const sector = {
    id,
    sector: sectorData.sector
  };

  let connection;
  try {
    connection = await mysqlPool.getConnection();
    const sqlQuery = `INSERT INTO sectors SET ?`;
    await connection.query(sqlQuery, sector);
    connection.release();

    res.header(
      "Location",
      `${process.env.HTTP_SERVER_DOMAIN}/v1/sectors/${sector.id}`
    );
    return res.status(201).send();
  } catch (e) {
    if (connection) {
      connection.release();
    }

    if (e.code === "ER_DUP_ENTRY") {
      return res.status(409).send("Sector already exists");
    }

    console.error(e);
    return res.status(500).send();
  }
}

module.exports = createSector;
