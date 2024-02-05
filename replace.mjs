import inquirer from "inquirer";
import fs from "fs-extra";
import path from "path";
import { glob } from "glob";

let currentDirectory = process.cwd();

async function displayDirectoryContents() {
  console.log(`Current directory: ${currentDirectory}`);
  const choices = fs
    .readdirSync(currentDirectory)
    .filter((item) =>
      fs.statSync(path.join(currentDirectory, item)).isDirectory()
    )
    .map((item) => ({ name: item, value: path.join(currentDirectory, item) }));
  choices.unshift({ name: "Go back a directory", value: "goBack" });
  choices.push({ name: "Confirm directory", value: "confirm" });

  const { choice } = await inquirer.prompt([
    {
      type: "list",
      name: "choice",
      message: "Select a directory:",
      choices,
    },
  ]);

  if (choice === "confirm") {
    return;
  } else if (choice === "goBack") {
    currentDirectory = path.resolve(currentDirectory, "..");
    await displayDirectoryContents();
  } else {
    currentDirectory = choice;
    await displayDirectoryContents();
  }
}

async function checkForStokeCuriosity(title) {
  if (title.includes("Instructor Do: Stoke Curiosity")) {
    const { continueEditing } = await inquirer.prompt([
      {
        type: "confirm",
        name: "continueEditing",
        message:
          "Warning: The title contains 'Instructor Do: Stoke Curiosity'. Do you want to continue?",
        default: false,
      },
    ]);

    if (!continueEditing) {
      throw new Error("Operation cancelled by the user.");
    }
  }
}

async function modifyMarkdownFiles(startTitle, newContent, endTitle) {
  let count = 0;
  await checkForStokeCuriosity(startTitle);
  await checkForStokeCuriosity(endTitle);

  // Adjust regex to match markdown headers with numbers
  const startTitleRegex = new RegExp(
    `(### [0-9]*\\. .*${startTitle})([\\s\\S]*?)(### [0-9]*\\. .*${endTitle})`,
    "g"
  );

  const markDownFiles = await glob(`${currentDirectory}/**/*.md`, {
    ignore: "**/Grading-Rubrics/**",
  });

  for (let file of markDownFiles) {
    let content = await fs.readFile(file, "utf8");
    let modified = content.replace(startTitleRegex, `$1\n\n${newContent}\n$3`);

    if (content !== modified) {
      await fs.writeFile(file, modified);
      count++;
      console.log(`Modified file: ${file}`);
    }
  }

  console.log(`Total files modified: ${count}`);
}

async function run() {
  await displayDirectoryContents();

  const { startTitle } = await inquirer.prompt([
    {
      type: "input",
      name: "startTitle",
      message: "Enter the text part of the starting block title:",
    },
  ]);

  const { newContent } = await inquirer.prompt([
    {
      type: "editor",
      name: "newContent",
      message: "Enter the new content:",
    },
  ]);

  const { endTitle } = await inquirer.prompt([
    {
      type: "input",
      name: "endTitle",
      message: "Enter the text part of the ending block title:",
    },
  ]);

  await modifyMarkdownFiles(startTitle, newContent, endTitle);
}

run().catch((error) => {
  console.error(error.message);
});
