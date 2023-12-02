const { chromium } = require('playwright');

let expiryTimestamp;

const hydra = 'https://bookings.drumshedslondon.com/landing?client_id=69&package_id=20092&agent_id=&adults=0&children=0&infants=0&currency_id=98';
const hydraButton = 3;

// const hydra = 'https://bookings.drumshedslondon.com/landing?client_id=69&package_id=20091&agent_id=&adults=0&children=0&infants=0&currency_id=98';
// const hydraButton = 4;

(async () => {
    try {
        const browser = await chromium.launch()
        const context = await browser.newContext();
        const page = await context.newPage()

        await page.goto(hydra);
        const addButton = await page.locator(`div.col-md-4.ticket-booking > div:nth-child(${hydraButton}) button.plus`);
        await addButton.click();
        await addButton.click();

        await page.locator("#booking-status-total-cost > div > div.btnContinue_wrapper > a").click()

        const timeRemaining = await page.locator("#main > div > div > div.header-basket-container > div.header-timer > small").textContent();

        const timeRemainingArray = timeRemaining.split(" ")[2].split(":");
        const expiryDate = new Date();
        expiryDate.setMinutes(expiryDate.getMinutes() + parseInt(timeRemainingArray[0]));
        expiryDate.setSeconds(expiryDate.getSeconds() + parseInt(timeRemainingArray[1]));
        const minutes = expiryDate.getMinutes().toString().slice(-1);
        const seconds = Math.floor(expiryDate.getSeconds() / 10);
        expiryTimestamp = parseInt(minutes + seconds.toString(), 10);
    } catch (e) {
        console.log(e)
        process.exit(0);
    }

    console.log(expiryTimestamp);
    process.exit(expiryTimestamp);
})()
