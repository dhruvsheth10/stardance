import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["container", "items", "item"];

  async remove(event) {
    event.preventDefault();

    const button = event.currentTarget;
    const item = button.closest(".shop-goals__item");
    if (!item || button.disabled) return;

    button.disabled = true;

    try {
      const response = await fetch(button.dataset.shopWishlistRailUrlParam, {
        method: "DELETE",
        credentials: "same-origin",
        headers: {
          "X-CSRF-Token": this.csrfToken,
          Accept: "application/json",
        },
      });

      if (!response.ok) throw new Error("Wishlist removal failed");

      const itemName = button.dataset.shopWishlistRailItemNameParam;
      this.removeItem(item);
      this.showToast(`${itemName} removed!`);
    } catch (_error) {
      button.disabled = false;
      this.showToast("Could not remove item. Try again.", "error");
    }
  }

  get csrfToken() {
    return document.querySelector('meta[name="csrf-token"]')?.content;
  }

  removeItem(item) {
    item.classList.add("shop-goals__item--removing");
    item.addEventListener(
      "transitionend",
      () => {
        item.remove();
        this.showEmptyStateIfNeeded();
      },
      { once: true },
    );

    setTimeout(() => {
      if (item.isConnected) {
        item.remove();
        this.showEmptyStateIfNeeded();
      }
    }, 260);
  }

  showEmptyStateIfNeeded() {
    if (this.itemTargets.some((item) => item.isConnected)) return;

    this.containerTarget.innerHTML = `
      <p class="discover-rail__placeholder-text">
        Tap the star on any item to add it here.
      </p>
    `;
  }

  showToast(message, type = "success") {
    this.toast?.remove();

    const toast = document.createElement("div");
    toast.className = `shop-wishlist-toast shop-wishlist-toast--${type}`;
    toast.setAttribute("role", "status");
    toast.setAttribute("aria-live", "polite");
    toast.textContent = message;
    document.body.appendChild(toast);

    this.toast = toast;
    requestAnimationFrame(() =>
      toast.classList.add("shop-wishlist-toast--visible"),
    );

    window.setTimeout(() => {
      toast.classList.remove("shop-wishlist-toast--visible");
      toast.addEventListener("transitionend", () => toast.remove(), {
        once: true,
      });
    }, 2400);
  }
}
