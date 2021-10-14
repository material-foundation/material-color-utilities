/*
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package scheme;

import palettes.CorePalette;

/** Represents a Material color scheme, a mapping of color roles to colors. */
public class Scheme {
  // Generated using https://www.jsonschema2pojo.org/

  private int primary;
  private int onPrimary;
  private int primaryContainer;
  private int onPrimaryContainer;
  private int secondary;
  private int onSecondary;
  private int secondaryContainer;
  private int onSecondaryContainer;
  private int tertiary;
  private int onTertiary;
  private int tertiaryContainer;
  private int onTertiaryContainer;
  private int error;
  private int onErrorContainer;
  private int outline;
  private int background;
  private int onBackground;
  private int surface;
  private int onSurface;
  private int surfaceVariant;
  private int onSurfaceVariant;
  private int inverseSurface;
  private int inverseOnSurface;

  public Scheme() {}

  public Scheme(
      int primary,
      int onPrimary,
      int primaryContainer,
      int onPrimaryContainer,
      int secondary,
      int onSecondary,
      int secondaryContainer,
      int onSecondaryContainer,
      int tertiary,
      int onTertiary,
      int tertiaryContainer,
      int onTertiaryContainer,
      int error,
      int onErrorContainer,
      int outline,
      int background,
      int onBackground,
      int surface,
      int onSurface,
      int surfaceVariant,
      int onSurfaceVariant,
      int inverseSurface,
      int inverseOnSurface) {
    super();
    this.primary = primary;
    this.onPrimary = onPrimary;
    this.primaryContainer = primaryContainer;
    this.onPrimaryContainer = onPrimaryContainer;
    this.secondary = secondary;
    this.onSecondary = onSecondary;
    this.secondaryContainer = secondaryContainer;
    this.onSecondaryContainer = onSecondaryContainer;
    this.tertiary = tertiary;
    this.onTertiary = onTertiary;
    this.tertiaryContainer = tertiaryContainer;
    this.onTertiaryContainer = onTertiaryContainer;
    this.error = error;
    this.onErrorContainer = onErrorContainer;
    this.outline = outline;
    this.background = background;
    this.onBackground = onBackground;
    this.surface = surface;
    this.onSurface = onSurface;
    this.surfaceVariant = surfaceVariant;
    this.onSurfaceVariant = onSurfaceVariant;
    this.inverseSurface = inverseSurface;
    this.inverseOnSurface = inverseOnSurface;
  }

  public static Scheme light(int argb) {
    CorePalette core = CorePalette.of(argb);
    return new Scheme()
        .withPrimary(core.a1.tone(40))
        .withOnPrimary(core.a1.tone(100))
        .withPrimaryContainer(core.a1.tone(90))
        .withOnPrimaryContainer(core.a1.tone(10))
        .withSecondary(core.a2.tone(40))
        .withOnSecondary(core.a2.tone(100))
        .withSecondaryContainer(core.a2.tone(90))
        .withOnSecondaryContainer(core.a2.tone(10))
        .withTertiary(core.a3.tone(40))
        .withOnTertiary(core.a3.tone(100))
        .withTertiaryContainer(core.a3.tone(90))
        .withOnTertiaryContainer(core.a3.tone(10))
        .withError(core.error.tone(40))
        .withOnErrorContainer(core.error.tone(100))
        .withOutline(core.n2.tone(50))
        .withBackground(core.n1.tone(90))
        .withOnBackground(core.n1.tone(10))
        .withSurface(core.n1.tone(99))
        .withOnSurface(core.n1.tone(0))
        .withSurfaceVariant(core.n2.tone(90))
        .withOnSurfaceVariant(core.n2.tone(80))
        .withInverseSurface(core.n1.tone(20))
        .withInverseOnSurface(core.n1.tone(95));
  }

  public static Scheme dark(int argb) {
    CorePalette core = CorePalette.of(argb);
    return new Scheme()
        .withPrimary(core.a1.tone(80))
        .withOnPrimary(core.a1.tone(20))
        .withPrimaryContainer(core.a1.tone(70))
        .withOnPrimaryContainer(core.a1.tone(10))
        .withSecondary(core.a2.tone(80))
        .withOnSecondary(core.a2.tone(20))
        .withSecondaryContainer(core.a2.tone(70))
        .withOnSecondaryContainer(core.a2.tone(10))
        .withTertiary(core.a3.tone(80))
        .withOnTertiary(core.a3.tone(20))
        .withTertiaryContainer(core.a3.tone(70))
        .withOnTertiaryContainer(core.a3.tone(10))
        .withError(core.error.tone(80))
        .withOnErrorContainer(core.error.tone(10))
        .withOutline(core.n2.tone(60))
        .withBackground(core.n1.tone(10))
        .withOnBackground(core.n1.tone(90))
        .withSurface(core.n1.tone(10))
        .withOnSurface(core.n1.tone(100))
        .withSurfaceVariant(core.n2.tone(30))
        .withOnSurfaceVariant(core.n2.tone(80))
        .withInverseSurface(core.n1.tone(90))
        .withInverseOnSurface(core.n1.tone(20));
  }

  public int getPrimary() {
    return primary;
  }

  public void setPrimary(int primary) {
    this.primary = primary;
  }

  public Scheme withPrimary(int primary) {
    this.primary = primary;
    return this;
  }

  public int getOnPrimary() {
    return onPrimary;
  }

  public void setOnPrimary(int onPrimary) {
    this.onPrimary = onPrimary;
  }

  public Scheme withOnPrimary(int onPrimary) {
    this.onPrimary = onPrimary;
    return this;
  }

  public int getPrimaryContainer() {
    return primaryContainer;
  }

  public void setPrimaryContainer(int primaryContainer) {
    this.primaryContainer = primaryContainer;
  }

  public Scheme withPrimaryContainer(int primaryContainer) {
    this.primaryContainer = primaryContainer;
    return this;
  }

  public int getOnPrimaryContainer() {
    return onPrimaryContainer;
  }

  public void setOnPrimaryContainer(int onPrimaryContainer) {
    this.onPrimaryContainer = onPrimaryContainer;
  }

  public Scheme withOnPrimaryContainer(int onPrimaryContainer) {
    this.onPrimaryContainer = onPrimaryContainer;
    return this;
  }

  public int getSecondary() {
    return secondary;
  }

  public void setSecondary(int secondary) {
    this.secondary = secondary;
  }

  public Scheme withSecondary(int secondary) {
    this.secondary = secondary;
    return this;
  }

  public int getOnSecondary() {
    return onSecondary;
  }

  public void setOnSecondary(int onSecondary) {
    this.onSecondary = onSecondary;
  }

  public Scheme withOnSecondary(int onSecondary) {
    this.onSecondary = onSecondary;
    return this;
  }

  public int getSecondaryContainer() {
    return secondaryContainer;
  }

  public void setSecondaryContainer(int secondaryContainer) {
    this.secondaryContainer = secondaryContainer;
  }

  public Scheme withSecondaryContainer(int secondaryContainer) {
    this.secondaryContainer = secondaryContainer;
    return this;
  }

  public int getOnSecondaryContainer() {
    return onSecondaryContainer;
  }

  public void setOnSecondaryContainer(int onSecondaryContainer) {
    this.onSecondaryContainer = onSecondaryContainer;
  }

  public Scheme withOnSecondaryContainer(int onSecondaryContainer) {
    this.onSecondaryContainer = onSecondaryContainer;
    return this;
  }

  public int getTertiary() {
    return tertiary;
  }

  public void setTertiary(int tertiary) {
    this.tertiary = tertiary;
  }

  public Scheme withTertiary(int tertiary) {
    this.tertiary = tertiary;
    return this;
  }

  public int getOnTertiary() {
    return onTertiary;
  }

  public void setOnTertiary(int onTertiary) {
    this.onTertiary = onTertiary;
  }

  public Scheme withOnTertiary(int onTertiary) {
    this.onTertiary = onTertiary;
    return this;
  }

  public int getTertiaryContainer() {
    return tertiaryContainer;
  }

  public void setTertiaryContainer(int tertiaryContainer) {
    this.tertiaryContainer = tertiaryContainer;
  }

  public Scheme withTertiaryContainer(int tertiaryContainer) {
    this.tertiaryContainer = tertiaryContainer;
    return this;
  }

  public int getOnTertiaryContainer() {
    return onTertiaryContainer;
  }

  public void setOnTertiaryContainer(int onTertiaryContainer) {
    this.onTertiaryContainer = onTertiaryContainer;
  }

  public Scheme withOnTertiaryContainer(int onTertiaryContainer) {
    this.onTertiaryContainer = onTertiaryContainer;
    return this;
  }

  public int getError() {
    return error;
  }

  public void setError(int error) {
    this.error = error;
  }

  public Scheme withError(int error) {
    this.error = error;
    return this;
  }

  public int getOnErrorContainer() {
    return onErrorContainer;
  }

  public void setOnErrorContainer(int onErrorContainer) {
    this.onErrorContainer = onErrorContainer;
  }

  public Scheme withOnErrorContainer(int onErrorContainer) {
    this.onErrorContainer = onErrorContainer;
    return this;
  }

  public int getOutline() {
    return outline;
  }

  public void setOutline(int outline) {
    this.outline = outline;
  }

  public Scheme withOutline(int outline) {
    this.outline = outline;
    return this;
  }

  public int getBackground() {
    return background;
  }

  public void setBackground(int background) {
    this.background = background;
  }

  public Scheme withBackground(int background) {
    this.background = background;
    return this;
  }

  public int getOnBackground() {
    return onBackground;
  }

  public void setOnBackground(int onBackground) {
    this.onBackground = onBackground;
  }

  public Scheme withOnBackground(int onBackground) {
    this.onBackground = onBackground;
    return this;
  }

  public int getSurface() {
    return surface;
  }

  public void setSurface(int surface) {
    this.surface = surface;
  }

  public Scheme withSurface(int surface) {
    this.surface = surface;
    return this;
  }

  public int getOnSurface() {
    return onSurface;
  }

  public void setOnSurface(int onSurface) {
    this.onSurface = onSurface;
  }

  public Scheme withOnSurface(int onSurface) {
    this.onSurface = onSurface;
    return this;
  }

  public int getSurfaceVariant() {
    return surfaceVariant;
  }

  public void setSurfaceVariant(int surfaceVariant) {
    this.surfaceVariant = surfaceVariant;
  }

  public Scheme withSurfaceVariant(int surfaceVariant) {
    this.surfaceVariant = surfaceVariant;
    return this;
  }

  public int getOnSurfaceVariant() {
    return onSurfaceVariant;
  }

  public void setOnSurfaceVariant(int onSurfaceVariant) {
    this.onSurfaceVariant = onSurfaceVariant;
  }

  public Scheme withOnSurfaceVariant(int onSurfaceVariant) {
    this.onSurfaceVariant = onSurfaceVariant;
    return this;
  }

  public int getInverseSurface() {
    return inverseSurface;
  }

  public void setInverseSurface(int inverseSurface) {
    this.inverseSurface = inverseSurface;
  }

  public Scheme withInverseSurface(int inverseSurface) {
    this.inverseSurface = inverseSurface;
    return this;
  }

  public int getInverseOnSurface() {
    return inverseOnSurface;
  }

  public void setInverseOnSurface(int inverseOnSurface) {
    this.inverseOnSurface = inverseOnSurface;
  }

  public Scheme withInverseOnSurface(int inverseOnSurface) {
    this.inverseOnSurface = inverseOnSurface;
    return this;
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append(Scheme.class.getName())
        .append('@')
        .append(Integer.toHexString(System.identityHashCode(this)))
        .append('[');
    sb.append("primary");
    sb.append('=');
    sb.append(this.primary);
    sb.append(',');
    sb.append("onPrimary");
    sb.append('=');
    sb.append(this.onPrimary);
    sb.append(',');
    sb.append("primaryContainer");
    sb.append('=');
    sb.append(this.primaryContainer);
    sb.append(',');
    sb.append("onPrimaryContainer");
    sb.append('=');
    sb.append(this.onPrimaryContainer);
    sb.append(',');
    sb.append("secondary");
    sb.append('=');
    sb.append(this.secondary);
    sb.append(',');
    sb.append("onSecondary");
    sb.append('=');
    sb.append(this.onSecondary);
    sb.append(',');
    sb.append("secondaryContainer");
    sb.append('=');
    sb.append(this.secondaryContainer);
    sb.append(',');
    sb.append("onSecondaryContainer");
    sb.append('=');
    sb.append(this.onSecondaryContainer);
    sb.append(',');
    sb.append("tertiary");
    sb.append('=');
    sb.append(this.tertiary);
    sb.append(',');
    sb.append("onTertiary");
    sb.append('=');
    sb.append(this.onTertiary);
    sb.append(',');
    sb.append("tertiaryContainer");
    sb.append('=');
    sb.append(this.tertiaryContainer);
    sb.append(',');
    sb.append("onTertiaryContainer");
    sb.append('=');
    sb.append(this.onTertiaryContainer);
    sb.append(',');
    sb.append("error");
    sb.append('=');
    sb.append(this.error);
    sb.append(',');
    sb.append("onErrorContainer");
    sb.append('=');
    sb.append(this.onErrorContainer);
    sb.append(',');
    sb.append("outline");
    sb.append('=');
    sb.append(this.outline);
    sb.append(',');
    sb.append("background");
    sb.append('=');
    sb.append(this.background);
    sb.append(',');
    sb.append("onBackground");
    sb.append('=');
    sb.append(this.onBackground);
    sb.append(',');
    sb.append("surface");
    sb.append('=');
    sb.append(this.surface);
    sb.append(',');
    sb.append("onSurface");
    sb.append('=');
    sb.append(this.onSurface);
    sb.append(',');
    sb.append("surfaceVariant");
    sb.append('=');
    sb.append(this.surfaceVariant);
    sb.append(',');
    sb.append("onSurfaceVariant");
    sb.append('=');
    sb.append(this.onSurfaceVariant);
    sb.append(',');
    sb.append("inverseSurface");
    sb.append('=');
    sb.append(this.inverseSurface);
    sb.append(',');
    sb.append("inverseOnSurface");
    sb.append('=');
    sb.append(this.inverseOnSurface);
    sb.append(',');
    if (sb.charAt((sb.length() - 1)) == ',') {
      sb.setCharAt((sb.length() - 1), ']');
    } else {
      sb.append(']');
    }
    return sb.toString();
  }

  @Override
  public int hashCode() {
    int result = 1;
    result = ((result * 31) + this.onPrimary);
    result = ((result * 31) + this.onSurface);
    result = ((result * 31) + this.surface);
    result = ((result * 31) + this.onPrimaryContainer);
    result = ((result * 31) + this.onTertiary);
    result = ((result * 31) + this.inverseOnSurface);
    result = ((result * 31) + this.primaryContainer);
    result = ((result * 31) + this.onSecondaryContainer);
    result = ((result * 31) + this.tertiaryContainer);
    result = ((result * 31) + this.secondaryContainer);
    result = ((result * 31) + this.tertiary);
    result = ((result * 31) + this.onTertiaryContainer);
    result = ((result * 31) + this.error);
    result = ((result * 31) + this.onErrorContainer);
    result = ((result * 31) + this.surfaceVariant);
    result = ((result * 31) + this.secondary);
    result = ((result * 31) + this.inverseSurface);
    result = ((result * 31) + this.outline);
    result = ((result * 31) + this.onSurfaceVariant);
    result = ((result * 31) + this.background);
    result = ((result * 31) + this.onBackground);
    result = ((result * 31) + this.onSecondary);
    result = ((result * 31) + this.primary);
    return result;
  }

  @Override
  public boolean equals(Object other) {
    if (other == null) {
      return false;
    }
    if (other == this) {
      return true;
    }
    if (!(other instanceof Scheme)) {
      return false;
    }
    Scheme rhs = ((Scheme) other);
    return (this.onPrimary == rhs.onPrimary)
        && (this.onSurface == rhs.onSurface)
        && (this.surface == rhs.surface)
        && (this.onPrimaryContainer == rhs.onPrimaryContainer)
        && (this.onTertiary == rhs.onTertiary)
        && (this.inverseOnSurface == rhs.inverseOnSurface)
        && (this.primaryContainer == rhs.primaryContainer)
        && (this.onSecondaryContainer == rhs.onSecondaryContainer)
        && (this.tertiaryContainer == rhs.tertiaryContainer)
        && (this.secondaryContainer == rhs.secondaryContainer)
        && (this.tertiary == rhs.tertiary)
        && (this.onTertiaryContainer == rhs.onTertiaryContainer)
        && (this.error == rhs.error)
        && (this.onErrorContainer == rhs.onErrorContainer)
        && (this.surfaceVariant == rhs.surfaceVariant)
        && (this.secondary == rhs.secondary)
        && (this.inverseSurface == rhs.inverseSurface)
        && (this.outline == rhs.outline)
        && (this.onSurfaceVariant == rhs.onSurfaceVariant)
        && (this.background == rhs.background)
        && (this.onBackground == rhs.onBackground)
        && (this.onSecondary == rhs.onSecondary)
        && (this.primary == rhs.primary);
  }
}
