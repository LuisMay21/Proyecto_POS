const express = require("express");
const router = express.Router();
const categoryController = require("../controller/categoryController");

router.post("/", categoryController.createCategory);
router.get("/:userId", categoryController.getCategories);
router.put("/:categoryId", categoryController.updateCategory);
router.delete("/:categoryId", categoryController.deleteCategory);

module.exports = router